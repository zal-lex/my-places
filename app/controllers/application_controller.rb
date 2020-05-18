# frozen_string_literal: true

# rubocop:disable Layout/LineLength
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:signin) }
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email password password_confirmation username name age sex avatar_url])
  end

  def after_sign_in_path_for(_resource)
    current_user
  end
end
# rubocop:enable Layout/LineLength
