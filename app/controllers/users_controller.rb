# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :load_user

  def profile
    authorize(@user)

    @type = type_scope
    @status = status_scope

    @ads = @user.ads

    @ads = @ads.public_send(@type) if @type
    @ads = @ads.public_send(@status) if @status

    @ads = @ads.recent_first.page(params[:page])
  end

  private

  def load_user
    @user = friendly_find(params[:username])
  end

  def friendly_find(param)
    User.legitimate.find_by(username: param) || User.legitimate.find(param)
  end
end
