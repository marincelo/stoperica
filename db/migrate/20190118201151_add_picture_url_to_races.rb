# frozen_string_literal: true

class AddPictureUrlToRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :picture_url, :string
  end
end
