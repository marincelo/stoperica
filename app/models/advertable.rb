# frozen_string_literal: true

class Advertable < ApplicationRecord
  belongs_to :race
  belongs_to :advertisement
end
