# frozen_string_literal: true

class AddCategoryToRacer < ActiveRecord::Migration[5.0]
  def change
    add_column :racers, :category, :integer
  end
end
