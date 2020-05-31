# frozen_string_literal: true

class Place < ApplicationRecord
  belongs_to :author, class_name: :User, foreign_key: :author_id, inverse_of: :places
  validates :title, presence: true, length: { maximum: 60 }
  validates :description, length: { maximum: 500 }
  validates :latitude, presence: true, numericality: { less_than_or_equal_to: 90,
                                                       greater_than_or_equal_to: -90 }
  validates :longitude, presence: true, numericality: { less_than_or_equal_to: 180,
                                                        greater_than_or_equal_to: -180 }
end
