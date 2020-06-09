# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(username: "tanya",
	        name: "tanya",
	        age: "2",
	        sex: "2",
			email: "YOUREMAIL",
			is_admin: true,
			password: "123123",
			password_confirmation: "123123")
10.times do |n|
	username = Faker::Name.name
	name = "tanya"
	age = 2,
	sex = 2,
	email = "tanya-#{n+1}@ya.ru"
	password = "123123"
	User.create!(username: username[5..15],
		        name: name,
		        age: 15,
	            sex: 2,
				email: email,
				password: password,
				password_confirmation: password)
end

users = User.order(:created_at).take(6)

6.times do |n|
	user = User.find(n+1)
	3.times do 
		title = Faker::Lorem.sentence
		description = Faker::Lorem.sentence
		latitude = rand(53.80..54.00) 
		longitude = rand(27.40..27.70)
		user.places.create!( title: title, description: description, latitude: latitude, longitude: longitude) 
  end
end

users = User.all
user = users.first
following = users[2..9]
following.each { |friend| user.follow(friend) }

users = User.order(:created_at).take(6)
6.times do |n|
	user = User.find(n+1)
	places = Place.all
	liking = places[1..15]
	liking.each { |place| user.fav_places.create!(likeable: place) }
end
