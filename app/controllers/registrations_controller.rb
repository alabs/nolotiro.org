# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    if params[:terms] || omniauth_registration? || verify_recaptcha
      super

      spam_control(request.remote_ip)
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = flash[:recaptcha_error]
      flash.delete :recaptcha_error
      render :new
    end
  end

  protected

  def after_update_path_for(resource)
    profile_path(resource.username)
  end

  private

  def spam_control(ip)
    resource.ban_and_save_ip!(ip) if resource.valid? && User.suspicious?(ip)
  end

  def omniauth_registration?
    session["devise.omniauth_data"]
  end

  helper_method :omniauth_registration?

  def omniauth_email?
    omniauth_registration? && session["devise.omniauth_data"]["info"]["email"]
  end

  helper_method :omniauth_email?
end
