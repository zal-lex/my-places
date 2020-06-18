# Favorite-Places App

## General info [my-places.site](https://my-places.site)

Favorite-Places is a Ruby-based social application for sharing with friends your beloved places. It allowes to set marks on Google maps with your photos and get likes on them. A user can see his own map with places he created, maps of other users and also a map with his favorite places on it. As an admin you can download a generated PDF file with statistics about users activity at the application.

## Screenshots

<img width=“964” alt="general view ot the app" src="https://github.com/RUBYLNIK-training-center/favorite-places-hufflepuff/blob/master/public/Screen%20Shot%201.png">

<img width=“964” alt="general view ot the app" src="https://github.com/RUBYLNIK-training-center/favorite-places-hufflepuff/blob/master/public/Screen%20Shot%202.png">

## Table of Contents

- [Favorite-Places App](#favorite-places-app)
  * [General info](#general-info)
  * [Screenshots](#screenshots)
  * [Technologies](#technologies)
  * [Install](#install)
    + [Clone the repository](#clone-the-repository)
    + [Check your Ruby version](#check-your-ruby-version)
    + [Install dependencies](#install-dependencies)
    + [Set environment variables](#set-environment-variables)
    + [Initialize the database](#initialize-the-database)
    + [Start the rails server](#start-the-rails-server)
    + [Add heroku remotes](#add-heroku-remotes)
  * [Running the tests](#running-the-tests)
    + [To run all tests with Rspec](#to-run-all-tests-with-rspec)
    + [And coding style tests with Rubocop](#and-coding-style-tests-with-rubocop)
  * [Questions](#questions)
  * [Authors](#authors)
  * [Acknowledgments](#acknowledgments)

## Technologies
Project is created with:

* Ruby version 2.6.3p62
* Rails version 6.0.3
* PostgreSQL version 12.2
* Devise (also OmniAuth with Facebook)
* Nginx + Passenger
* VPS DigitalOcean
* Carrierwave, Active Storage and rmagick at Amazon S3
* Redis, ActiveJob + Resque
* Capistrano
* Bootstrap 4.5.0
* PDFKit
* SimpleCov
* Google Maps API
* Postfix
* RSpec, Factory Bot, Shoulda Matchers and JsonMatchers

## Install

### Clone the repository

```shell
git clone git@github.com:RUBYLNIK-training-center/favorite-places-hufflepuff.git
cd project
```

### Check your Ruby version

```shell
ruby -v
```
The ouput should start with something like `ruby 2.6.3`


### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [Yarn](https://github.com/yarnpkg/yarn):

```shell
bundle && yarn
```
Install gem rmagick if needed.

```shell
brew install imagemagick
   or
sudo apt-get install libmagickwand-dev imagemagick
```

### Set environment variables

Use your preferred way of storing environment variables and set the following ENV:
```shell
ENV['DATABASE_URL']
ENV['FAVORITE_PLACES_DATABASE_USER']
ENV['FAVORITE_PLACES_DATABASE_PASSWORD']
ENV['RAILS_MASTER_KEY']
ENV['SECRET_KEY_BASE']
ENV['S3_ACCESS_KEY']
ENV['S3_SECRET_KEY']
ENV['S3_BUCKET_NAME']
ENV['FB_APP_ID']
ENV['FB_APP_SECRET']
ENV['MAILER_EMAIL']
ENV['MAILER_PASSWORD']

```

The application use Google Maps. For it's correct performance, get API Key and set it:
```shell
ENV['GM_API']
```

### Initialize the database

```shell
rails db:create db:migrate db:seed
```
The application is provided with a seed.rb file, that creates 12 users with avatars, friendships relations and their places on maps. To run db:seed put 12 images named "user0.jpg", "user1.jpg" respectively in folder app/assets/images/ 

### Start the rails server
You can start the rails server using the command given below.
```shell
bundle exec rails s
```
And now you can visit the site with the URL http://localhost:3000


### Add heroku remotes

Using [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli):

```shell
heroku git:remote -a project
heroku git:remote --remote heroku-staging -a project-staging
```
In production images are stored on Amazon AWS. Place environmental variables ENV in a file .env in a root of the application:
```shell
S3_ACCESS_KEY: # your key
S3_BUCKET_NAME: # name of your bucket
S3_SECRET_KEY: # your secret key
```
## Running the tests
The application has 98% test coverage, that are requests and model tests mainly.

### To run all tests with Rspec
```shell
rspec
```

### And coding style tests with Rubocop
To run coding style tests:
```
rubocop
```

## Questions
Please open an issue on this repo.

## Authors

* **Hufflepuff team** - * Alexey Zalyotov, Vadim Volovenko and Tatyana Zenkovich * - 

## Acknowledgments

* Hat tip to Alexander Shagov, Boris Tsarikov, Violetta Mironchik and Vlad Hilko
* Inspiration by Alexander Shagov
* Produced during EPAM Ruby Labs Course
