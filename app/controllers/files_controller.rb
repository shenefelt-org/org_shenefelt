# frozen_string_literal: true

# Designed to work with Cloudflare R2 Storage
# All authenticated users can view and download files.
# Only Admin users are authorized to upload or delete files.
class FilesController < ApplicationController
  before_action :require_admin!, only: %i[create upload destroy]

  # GET /files
  def index
    @prefix = params[:prefix].to_s
    raw = fetch_r2_list(@prefix)
    @files = Array(raw).map { |obj| normalize_r2_object(obj) }.compact
    Rails.logger.info("[R2] count=#{@files.size}")
  rescue => e
    Rails.logger.error("[R2] #{e.class}: #{e.message}\n#{e.backtrace.first(8).join("\n")}")
    @files = []
    flash.now[:alert] = "Could not list files: #{e.class}: #{e.message}"
  end

  
  def download
    key = params[:key].to_s
    return redirect_to(files_path, alert: "Missing file key.") if key.blank?
    return redirect_to(files_path, alert: "Invalid file key.") if key.include?("..") || key.start_with?("/")

    url = presigned_download_url(key)
    redirect_to url, allow_other_host: true
  rescue => e
    Rails.logger.error("[R2] download #{e.class}: #{e.message}")
    redirect_to files_path, alert: "Download failed: #{e.message}"
  end

  # POST /files
  def create
    file = params[:file] || Array(params[:files]).first
    return redirect_to(files_path, alert: "Please select a file to upload.") if file.blank?

    key = params[:key].to_s.presence || file.original_filename

    r2_client.put_object(
      bucket: r2_bucket,
      key: key,
      body: file.tempfile,
      content_type: file.content_type
    )

    redirect_to files_path, notice: "File '#{key}' uploaded successfully."
  rescue => e
    Rails.logger.error("[R2] upload #{e.class}: #{e.message}")
    redirect_to files_path, alert: "Upload failed: #{e.message}"
  end
  alias_method :upload, :create

  # DELETE /files/destroy
  def destroy
    key = params[:key].to_s
    return redirect_to(files_path, alert: "Missing file key.") if key.blank?
    return redirect_to(files_path, alert: "Invalid file key.") if key.include?("..") || key.start_with?("/")

    r2_client.delete_object(
      bucket: r2_bucket,
      key: key
    )

    redirect_to files_path, notice: "File '#{key}' deleted successfully."
  rescue => e
    Rails.logger.error("[R2] Delete error: #{e.message}")
    redirect_to files_path, alert: "Deletion failed: #{e.message}"
  end

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to files_path, alert: "You are not authorized to modify files."
    end
  end

  def fetch_r2_list(prefix)
    if R2ServiceHelper.respond_to?(:list_objects)
      return safe_list(:list_objects, prefix)
    end
    if R2ServiceHelper.respond_to?(:list)
      return safe_list(:list, prefix)
    end

    helper = R2ServiceHelper.new
    return safe_list_on(helper, :list_objects, prefix) if helper.respond_to?(:list_objects)
    return safe_list_on(helper, :list, prefix) if helper.respond_to?(:list)

    raise "R2ServiceHelper has no list/list_objects method"
  end

  def safe_list(method_name, prefix)
    if prefix.present?
      R2ServiceHelper.public_send(method_name, prefix: prefix)
    else
      R2ServiceHelper.public_send(method_name)
    end
  rescue ArgumentError
    R2ServiceHelper.public_send(method_name)
  end

  def safe_list_on(helper, method_name, prefix)
    if prefix.present?
      helper.public_send(method_name, prefix: prefix)
    else
      helper.public_send(method_name)
    end
  rescue ArgumentError
    helper.public_send(method_name)
  end

  def normalize_r2_object(obj)
    h =
      case obj
      when Hash
        {
          key: obj[:key] || obj["key"] || obj[:name] || obj["name"],
          size: obj[:size] || obj["size"],
          last_modified: obj[:last_modified] || obj["last_modified"]
        }
      when String
        { key: obj, size: nil, last_modified: nil }
      else
        {
          key: obj.try(:key) || obj.try(:name),
          size: obj.try(:size),
          last_modified: obj.try(:last_modified)
        }
      end
    return nil if h[:key].blank?
    h
  end

  def r2_config
    Rails.application.credentials[:cloudflare_r2] ||
      Rails.application.credentials[:r2] ||
      raise("Missing cloudflare_r2 / r2 credentials")
  end

  def r2_client
    if R2ServiceHelper.respond_to?(:client)
      return R2ServiceHelper.client
    end
    if defined?(R2ServiceHelper) && R2ServiceHelper.instance_methods.include?(:client)
      return R2ServiceHelper.new.client
    end

    cfg = r2_config
    endpoint =
      cfg[:endpoint].presence ||
      (cfg[:account_id].to_s.start_with?("http") ? cfg[:account_id] : nil) ||
      "https://#{cfg.fetch(:account_id)}.r2.cloudflarestorage.com"

    require "aws-sdk-s3"
    Aws::S3::Client.new(
      access_key_id: cfg.fetch(:access_key_id),
      secret_access_key: cfg[:secret_access_key] || cfg.fetch(:secret),
      endpoint: endpoint,
      region: cfg[:region].presence || "auto",
      force_path_style: true
    )
  end

  def r2_bucket
    if R2ServiceHelper.respond_to?(:bucket)
      return R2ServiceHelper.bucket
    end
    r2_config.fetch(:bucket)
  end

  def presigned_download_url(key, expires_in: 15.minutes)
    if R2ServiceHelper.respond_to?(:presigned_url)
      return R2ServiceHelper.presigned_url(key, expires_in: expires_in.to_i)
    end
    if R2ServiceHelper.respond_to?(:download_url)
      return R2ServiceHelper.download_url(key)
    end

    require "aws-sdk-s3"
    signer = Aws::S3::Presigner.new(client: r2_client)
    signer.presigned_url(
      :get_object,
      bucket: r2_bucket,
      key: key,
      expires_in: expires_in.to_i,
      response_content_disposition: content_disposition_for(key)
    )
  end

  def content_disposition_for(key)
    filename = File.basename(key)
    "attachment; filename=\"#{filename.gsub('"', '')}\""
  end
end