# frozen_string_literal: true

class AddCodeToClubs < ActiveRecord::Migration[5.1]
  def change
    add_column :clubs, :code, :string
  end
end
