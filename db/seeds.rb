# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.new(username: "Dumbledore",
             name: "Dumbledore",
             age: "111",
             sex: "1",
             email: "admin@hogwarts.com",
             is_admin: true,
             avatar_url: Rails.root.join("app/assets/images/user0.jpg").open,
             password: "123123",
             password_confirmation: "123123")
admin.skip_confirmation!
admin.save!
10.times do |n|
  username = Faker::Name.name
  name = Faker::Name.name
  age = 2,
  sex = 2,
  email = "tanya-#{n+1}@ya.ru"
  password = "123123"
  avatar_url = Rails.root.join("app/assets/images/user#{n+1}.jpg").open
  user = User.new(username: username[5..15],
                  name: name,
                  age: 15,
                  sex: 2,
                  email: email,
                  avatar_url: avatar_url,
                  password: password,
                  password_confirmation: password)
  user.skip_confirmation!
  user.save!
end

11.times do |n|
  user = User.find(11-n)
  (12-n).times do
    title = Faker::Lorem.sentence
    description = Faker::Lorem.sentence
    latitude = rand(53.80..54.00)
    longitude = rand(27.40..27.70)
    user.places.create!( title: title, description: description, latitude: latitude, longitude: longitude)
  end
end

  users = User.all
11.times do |n|
  user = User.find(n+1)
  following = users[1..11-n]
  following.each { |friend| user.follow(friend) }
end

11.times do |n|
  user = User.find(n+1)
  places = Place.all
  liking = places[1..70-5*n]
  liking.each { |place| user.fav_places.create!(likeable: place) }
end
