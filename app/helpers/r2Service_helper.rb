require "aws-sdk-s3"

module R2ServiceHelper
  def self.client
    cfg = Rails.application.credentials.fetch(:r2)

    Aws::S3::Client.new(
      access_key_id: cfg.fetch(:access_key_id),
      secret_access_key: cfg.fetch(:secret_access_key),
      endpoint: cfg.fetch(:endpoint),
      region: cfg[:region].presence || "auto",
      force_path_style: true
    )
  end
  

  def self.bucket
    Rails.application.credentials.dig(:r2, :bucket)
  end

  # Returns array of hashes: key, size, last_modified, etag
  def self.list_objects(prefix: nil, max_keys: 1000)
    client = self.client
    bucket = self.bucket
    objects = []
    token = nil

    loop do
      resp = client.list_objects_v2(
        bucket: bucket,
        prefix: prefix.presence,
        continuation_token: token,
        max_keys: [ max_keys, 1000 ].min
      )

      resp.contents.each do |obj|
        objects << {
          key: obj.key,
          size: obj.size,
          last_modified: obj.last_modified,
          etag: obj.etag
        }
      end

      break unless resp.is_truncated
      token = resp.next_continuation_token
      break if objects.size >= max_keys
    end

    objects.first(max_keys)
  end

  def self.delete_object(key)
    client = self.client
    bucket = self.bucket

    client.delete_object(
      bucket: bucket,
      key: key
    )
  end
end
