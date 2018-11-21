# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include MultiLingualizable
  include Pundit

  # TODO: comment captcha for ad creation/edition

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do |_exception|
    redirect_to request.referer || root_path, alert: t("nlt.permission_denied")
  end

  def access_denied(exception)
    redirect_to root_url, alert: exception.message
  end

  def signed_in_root_path(resource)
    woeid = resource.woeid
    return ads_woeid_path(woeid, type: "give") if woeid

    location_ask_path
  end

  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.admin?

    flash[:alert] = t("nlt.permission_denied")
    redirect_to root_path
  end

  def type_scope
    %w[give want].include?(params[:type]) ? params[:type] : nil
  end

  def status_scope
    return unless %w[available booked delivered expired].include?(params[:status])

    "currently_#{params[:status]}"
  end

  def location_suggest
    @location_suggest ||= RequestGeolocator.new(request.remote_ip).suggest
  end

  helper_method :location_suggest

  def comment_counts
    @comment_counts ||=
      policy_scope(Comment.where(ads_id: @ads.ids)).group(:ads_id).size
  end

  helper_method :comment_counts

  def conversations_count
    @conversations_count ||=
      policy_scope(Conversation.unread_by(current_user)).size
  end

  helper_method :conversations_count

  def current_woeid
    @current_woeid ||=
      if request.path =~ %r{/listall/} || params[:controller] == "users"
        nil
      else
        params[:id].presence || user_woeid
      end
  end

  helper_method :current_woeid

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username email password password_confirmation remember_me terms])

    devise_parameter_sanitizer.permit(:sign_in,
                                      keys: %i[username email password remember_me])

    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:username])
  end

  private

  def user_woeid
    current_user.try(:woeid)
  end
end
