# frozen_string_literal: true

class FavPlace < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user, class_name: 'User'
end
