# frozen_string_literal: true

json.id place.id
json.title place.title
json.description place.description
json.latitude place.latitude
json.longitude place.longitude
json.photos do
  json.array! place.photos do |photo|
    json.photo_url url_for(photo)
    json.photo_alt photo.filename
  end
end
