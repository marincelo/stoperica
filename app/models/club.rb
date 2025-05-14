# frozen_string_literal: true

class Club < ApplicationRecord
  belongs_to :user, optional: true
  has_many :racers
  has_many :club_league_points
  has_many :leagues, through: :club_league_points

  enum category: %i[biciklisticki triatlon atletski skole ostali penjacki trail-trekking trkacki-running pro timovi daljinsko-plivanje]

  default_scope { order(name: :asc) }

  def points_in_race(race)
    ebike_categories = Category.where(category: [Category.categories[:ebikem], Category.categories[:ebikez]])
    results = RaceResult
      .where(racer_id: racer_ids, race: race)
      .where.not(category_id: ebike_categories)
    results.sum(:points) + results.sum(:additional_points)
  end
end
