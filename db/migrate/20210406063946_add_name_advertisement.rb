# frozen_string_literal: true

class AddNameAdvertisement < ActiveRecord::Migration[5.1]
  def change
    add_column :advertisements, :name, :string
  end
end
