# frozen_string_literal: true

json.extract! race_result, :id, :racer_id, :race_id, :status, :lap_times, :created_at, :updated_at, :finish_time,
              :points, :start_number, :category
json.url race_result_url(race_result, format: :json)
