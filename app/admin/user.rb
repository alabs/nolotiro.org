# frozen_string_literal: true

require 'helpers/stats_sidebar'

ActiveAdmin.register User do
  include StatsSidebar

  config.batch_actions = false

  actions :index, :show, :update, :edit

  permit_params :role

  scope 'Legítimos', :legitimate, default: true
  scope 'Baneados', :banned

  controller do
    def find_collection
      super(except: :sorting)
    end

    def scoped_collection
      if current_scope.scope_method == :legitimate
        super.order(created_at: :desc)
      else
        super.order(banned_at: :desc)
      end
    end
  end

  filter :username
  filter :email
  filter :confirmed_at
  filter :last_sign_in_ip
  filter :last_sign_in_at
  filter :ads_count

  show do
    attributes_table do
      row :id
      row :username
      row :legacy_password_hash
      row :email
      row :created_at
      row :active
      row :role
      row :woeid
      row :sign_in_count
      row :last_sign_in_ip
      row :last_sign_in_at
      row :confirmed_at
      row :banned_at
      row :ads_count
    end

    panel 'Anuncios' do
      table_for user.ads.order(published_at: :desc) do
        column(:title) { |ad| link_to ad.title, admin_ad_path(ad) }

        column :published_at

        column :type do |ad|
          status_tag({ 'give' => 'green', 'want' => 'red' }[ad.type],
                     label: ad.type)
        end

        column :status do |ad|
          status_tag({ 'available' => 'green',
                       'booked' => 'orange',
                       'delivered' => 'red' }[ad.status],
                     label: ad.status)
        end

        column :body

        column :actions do |ad|
          edit = link_to 'Editar', edit_admin_ad_path(ad)
          delete = link_to 'Eliminar', admin_ad_path(ad), method: :delete

          safe_join([edit, delete], ' ')
        end
      end
    end
  end

  index do
    column(:username) { |user| link_to user.username, admin_user_path(user) }
    column :email
    column :confirmed_at

    column(:banned_at) if current_scope.scope_method == :banned

    column :last_sign_in_ip
    column :last_sign_in_at
    column :ads_count

    actions(defaults: false, dropdown: true) do |user|
      item 'Editar', edit_admin_user_path(user)
      item 'Contactar', new_conversation_path(recipient_id: user.id)
      item "#{user.banned? ? 'Desb' : 'B'}loquear",
           moderate_admin_user_path(user),
           method: :post
    end
  end

  action_item :view, only: :show do
    link_to('Ver en la web', profile_path(user.username)) if user.legitimate?
  end

  action_item :contact, only: :show do
    link_to 'Contactar', new_conversation_path(recipient_id: user.id) if user.legitimate?
  end

  action_item :moderate, only: :show do
    link_to "#{user.banned? ? 'Desb' : 'B'}loquear usuario",
            moderate_admin_user_path(user),
            method: :post
  end

  member_action :moderate, method: :post do
    user = User.find(params[:id])

    user.moderate!

    redirect_back fallback_location: admin_reported_users_path,
                  notice: "Usuario #{'des' unless user.banned?}bloqueado"
  end
end
