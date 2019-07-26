# frozen_string_literal: true

class EnsureUnaccentEnabled < ActiveRecord::Migration[4.2]
  def change
    reversible do |direction|
      direction.up do
        unless extension_enabled?('unaccent')
          execute "CREATE EXTENSION unaccent;"
        end
      end
    end
  end
end
