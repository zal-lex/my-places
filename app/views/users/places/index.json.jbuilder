# frozen_string_literal: true

json.array! @places, partial: 'users/places/place', as: :place
