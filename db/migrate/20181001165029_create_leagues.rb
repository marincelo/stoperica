# frozen_string_literal: true

class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.string :name

      t.timestamps
    end
  end
end
