# frozen_string_literal: true

class RaceAdmin < ApplicationRecord
  belongs_to :racer
  belongs_to :race
end
