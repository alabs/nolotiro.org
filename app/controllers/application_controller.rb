class ApplicationController < ActionController::Base
  # TODO: comment captcha for ad creation/edition
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in? 
      redirect_to root_url, :alert => t('nlt.permission_denied')
    else
      redirect_to new_user_session_url, :alert => exception.message
    end
  end

  def access_denied exception
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-in
    if request.referer and ["user/reset/edit", new_user_session_url].any? {|w| request.referer.include? w }
      super
    else
      initial_path = current_user.woeid? ? ads_woeid_path(id: current_user.woeid, type: 'give') : location_ask_path
      stored_location_for(resource) || request.referer || initial_path
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    #logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { locale: I18n.locale }
  end
  
  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = t('nlt.permission_denied')
      redirect_to root_path
    end
  end

  def type_scope
    params[:type] == 'want' ? params[:type] : 'give'
  end

  helper_method :type_scope

  protected

  def get_location_suggest 
    ip_address = GeoHelper.get_ip_address request
    GeoHelper.suggest ip_address
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
  end

end
