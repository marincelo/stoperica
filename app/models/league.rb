class League < ApplicationRecord
  has_many :races
  has_and_belongs_to_many :clubs

  enum league_type: [:xczld]
end
