# frozen_string_literal: true

require 'helpers/stats_sidebar'

ActiveAdmin.register Comment, as: 'AaComment' do
  include StatsSidebar

  permit_params :body

  filter :created_at
  filter :user_username, as: :string, label: I18n.t('nlt.username')

  controller do
    def scoped_collection
      super.includes :ad, :user
    end
  end

  index do
    selectable_column
    column :ad
    column :body
    column :user
    column :ip
    column :created_at
    actions(dropdown: true)
  end

  form do |f|
    f.inputs { f.input :body }

    f.actions
  end

  action_item :view, only: :show do
    link_to 'Ver en la web', adslug_path(aa_comment.ad, slug: aa_comment.ad.slug)
  end
end
