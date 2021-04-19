# frozen_string_literal: true

class CreateAdvertisements < ActiveRecord::Migration[5.1]
  def change
    create_table :advertisements do |t|
      t.integer :position
      t.string :image_url
      t.string :site_url
      t.datetime :expire_at

      t.timestamps
    end
  end
end
