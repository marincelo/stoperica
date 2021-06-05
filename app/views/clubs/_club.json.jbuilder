# frozen_string_literal: true

json.extract! club, :id, :name, :user_id, :created_at, :updated_at
json.url club_url(club, format: :json)
