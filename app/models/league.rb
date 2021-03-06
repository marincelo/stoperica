# frozen_string_literal: true

class League < ApplicationRecord
  has_many :races
  has_many :club_league_points
  has_many :clubs, through: :club_league_points
  enum league_type: %i[xczld lead running trail stage_competitors_only]
  before_validation :generate_slug

  def to_param
    name.parameterize
  end

  def generate_slug
    self.slug = name.parameterize
  end

  def racers
    categories = RaceResult
                 .includes(:category, racer: :club)
                 .where(race_id: races.ids)
                 .where.not(points: nil)
                 .group_by { |rr| rr.category.category }
    categories.each do |key, rrs|
      categories[key] = rrs.group_by(&:racer_id)
    end
  end

  def points
    if xczld?
      [
        250, 200, 160, 150, 140, 130, 120, 110, 100, 90, 80, 75, 70, 65, 60, 55,
        50, 45, 40, 35, 30, 25, 20, 15, 10
      ]
    elsif lead?
      [
        100, 80, 65, 55, 51, 47, 43, 40, 37, 34, 31, 28, 26, 24, 22, 20, 18, 16,
        14, 12, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
      ]
    elsif trail?
      [
        100, 88, 78, 72, 68, 66, 64, 62, 60, 58, 56, 54, 52, 50, 48, 46, 44, 42,
        40, 38, 36, 34, 32, 30, 28, 26, 24, 22, 20, 18, 17, 16, 15, 14, 13, 12,
        11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
      ]
    else
      []
    end
  end

  def general_rank # rubocop:disable Metrics/AbcSize
    rank = {}
    base_time = Time.parse '0:0:0'
    races.includes(race_results: :category).each do |race|
      race.race_results.each do |result|
        # rubocop:disable Style/GuardClause
        if result.finish_time.length > 3
          finish_time = Time.parse(result.finish_time)
        else
          next
        end
        # rubocop:enable Style/GuardClause

        category = result.category.category

        total_time = rank.dig(category, result.racer_id)&.[](0)
        if total_time.blank?
          if rank[category].blank?
            rank[category] = { result.racer_id => [finish_time, 1] }
          else
            rank[category][result.racer_id] = [finish_time, 1]
          end
        else
          rank[category][result.racer_id][0] = total_time + finish_time.hour.hours + finish_time.min.minutes +
                                               finish_time.sec.seconds
          rank[category][result.racer_id][1] += 1
        end
      end
    end

    r = rank.each { |k, rr| rank[k] = rr.sort_by { |_, time| [-time[1], (time[0] - base_time)] } }
    [r, base_time]
  end

  def self.seconds_to_str(seconds)
    [format('%.2i', (seconds / 3600).to_i), format('%.2i', (seconds / 60 % 60).to_i),
     format('%.2i', (seconds % 60).to_i)].join(':')
  end
end
