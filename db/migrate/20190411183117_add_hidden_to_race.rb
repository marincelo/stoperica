# frozen_string_literal: true

class AddHiddenToRace < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :hidden, :boolean, default: false
  end
end
