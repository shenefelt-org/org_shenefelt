class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  
  # 1. ADD THIS LINE: It tells Rails that Pundit and your HTML views are allowed to use this method
  helper_method :current_user

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  # 2. ADD THIS METHOD: This is what Pundit is crashing trying to find!
  def current_user
    Current.session&.user
  end
end