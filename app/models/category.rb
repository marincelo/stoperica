# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :race
  has_many :race_results
  enum category: %i[zene u16 16-20 20-30 30-40 40-50 50 muskarci u9m u9w u11m u11w u13m u13w u15m u15w u17
                    17-19 19-30 zeneu30 zene30 ebikem ebikez seniori juniori mladi u7m u7z u23 u30
                    veteran_a veteran_b veteran_c veteran_d zeneu35 zene35]

  def started?
    race_results.count.positive? && race_results.first.started_at.present?
  end

  def started_at
    race_results.count.positive? && race_results.first.started_at
  end

  def self.generics
    { 'zene' => categories[:zene], 'muskarci' => categories[:muskarci] }
  end
end
