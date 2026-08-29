class InjuryReportsController < ApplicationController
  before_action :require_reporter_login!, only: [ :index, :show ]
  before_action :set_injury_report, only: [ :show ]
  before_action :load_locations, only: [ :new, :create ]

  def index
    @injury_reports = InjuryReport.order(created_at: :desc)
  end

  def show
    @previous_injury_report = InjuryReport
      .where("created_at > ?", @injury_report.created_at)
      .order(created_at: :asc)
      .first

    @next_injury_report = InjuryReport
      .where("created_at < ?", @injury_report.created_at)
      .order(created_at: :desc)
      .first
  end

  def new
    @injury_report = InjuryReport.new(default_reporter_attributes)
    apply_default_location!(@injury_report)
  end

  def create
    @injury_report = InjuryReport.new(injury_report_params)
    apply_logged_in_reporter!(@injury_report)

    if @injury_report.save
      InjuryReportMailer.new_report(@injury_report).deliver_later
      # Use deliver_now if Active Job is not set up:
      # InjuryReportMailer.new_report(@injury_report).deliver_now

      redirect_to report_injury_path, notice: "Thank you. Your injury report has been submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_injury_report
    @injury_report = InjuryReport.find(params[:id])
  end

  def load_locations
    @locations = Location.includes(:company).order(:name)
  end

  def apply_default_location!(report)
    return if report.location.present?

    loc = current_reporter&.try(:employee_config)&.try(:location)
    report.location = loc.name if loc&.name.present?
  end

  def injury_report_params
    params.require(:injury_report).permit(
      :name, :email, :phone, :injured_person,
      :incident_date, :location, :description, :severity
    )
  end

  def default_reporter_attributes
    user = current_reporter
    return {} unless user

    {
      name: reporter_name(user),
      email: reporter_email(user)
    }.compact
  end

  def apply_logged_in_reporter!(report)
    user = current_reporter
    return unless user

    name_from_user = reporter_name(user)
    email_from_user = reporter_email(user)

    report.name = name_from_user if name_from_user.present?
    report.email = email_from_user if email_from_user.present?
  end

  def reporter_email(user)
    user.try(:email).presence || user.try(:email_address).presence
  end

  def reporter_name(user)
    # Names live on User; keep config fallbacks for older rows
    config = user.try(:employee_config)
    first_name = user.try(:first_name).presence || config.try(:first_name)
    last_name  = user.try(:last_name).presence  || config.try(:last_name)

    full_name = [ first_name, last_name ].compact_blank.join(" ")
    full_name.presence || user.try(:name).presence || user.try(:full_name).presence
  end

  def current_reporter
    @user ||
      (defined?(Current) && Current.respond_to?(:user) && Current.user) ||
      (respond_to?(:current_user, true) && current_user) ||
      nil
  end

  def logged_in_reporter?
    current_reporter.present?
  end

  def require_reporter_login!
    return if logged_in_reporter?

    redirect_to report_injury_path, alert: "You must be signed in to view injury reports."
  end

  helper_method :logged_in_reporter?, :current_reporter, :reporter_email, :reporter_name
end