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
			email: "tanya@ya.ru",
			password: "123123",
			password_confirmation: "123123")
10.times do |n|
	username = Faker::Name.name
	name = "tanya"
	age = 2,
	sex = 2,
	email = "tanya-#{n+1}@ya.ru"
	password = "123123"
	User.create!(username: username,
		        name: name,
		        age: 15,
	            sex: 2,
				email: email,
				password: password,
				password_confirmation: password)
end

users = User.order(:created_at).take(6)
10.times do
title = Faker::Lorem.sentence
latitude = rand(-90..90)
longitude = rand(-90..90)
users.each { |user| user.places.create!(title: title, latitude: latitude, longitude: longitude) }
end

users = User.all
user = users.first
following = users[2..9]
following.each { |friend| user.follow(friend) }
