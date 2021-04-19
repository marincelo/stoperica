# frozen_string_literal: true

class Pool < ApplicationRecord
  has_many :races
  has_many :start_numbers
end
