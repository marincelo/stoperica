# frozen_string_literal: true

class Advertisement < ApplicationRecord
  validates :position, :image_url, :site_url, :expire_at, presence: true

  has_many :advertables, dependent: :destroy
  has_many :races, through: :advertables

  scope :active, -> { where('expire_at > now()') }
  scope :expired, -> { where('expire_at =< now()') }

  def expire!
    update(expire_at: Time.now.utc)
  end
end
