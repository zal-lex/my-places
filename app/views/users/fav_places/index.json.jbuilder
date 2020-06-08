# frozen_string_literal: true

json.array! @places, partial: 'users/fav_places/fav_place', as: :place
