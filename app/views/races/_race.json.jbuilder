# frozen_string_literal: true

json.extract! race, :id, :name, :date, :laps, :easy_laps, :created_at, :updated_at, :started_at, :ended_at, :picture_url
json.url race_url(race, format: :json)
