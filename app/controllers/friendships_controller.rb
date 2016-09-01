# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.friendships.find_or_create_by!(friend_id: params[:friend_id])

    redirect_to :back, notice: I18n.t('friendships.create.success')
  end

  def destroy
    current_user.friendships.destroy(params[:id])

    redirect_to :back, notice: I18n.t('friendships.destroy.success')
  end
end
