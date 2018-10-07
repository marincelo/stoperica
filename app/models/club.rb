class Club < ApplicationRecord
  belongs_to :user, optional: true
  has_many :racers
  has_and_belongs_to_many :leagues

  enum category: %i[biciklisticki triatlon atletski skole ostali]

  default_scope { order(name: :asc) }
end
