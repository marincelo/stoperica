# frozen_string_literal: true

class Advertisement < ApplicationRecord

  has_many :advertables, dependent: :destroy
  has_many :races, through: :advertables

  enum position: ['For Race', '1', '2', '3', '4', '5', '1B']

  scope :active, -> { where('expire_at > now()') }
  scope :expired, -> { where('expire_at =< now()') }

  validates :position, :image_url, :site_url, :expire_at, presence: true


  def expire!
    update(expire_at: Time.now.utc)
  end
end
