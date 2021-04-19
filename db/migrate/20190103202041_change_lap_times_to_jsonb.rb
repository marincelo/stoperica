# frozen_string_literal: true

class ChangeLapTimesToJsonb < ActiveRecord::Migration[5.1]
  def change
    change_column :race_results, :lap_times, :text, array: true, default: nil
    change_column :race_results, :lap_times, :jsonb, using: 'to_json(lap_times)'
    change_column :race_results, :lap_times, :jsonb, default: []
  end
end
