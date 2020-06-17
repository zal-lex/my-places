# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FavoritePlaces
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    
		config.exception_handler = {
		dev: true, # allows you to turn ExceptionHandler "on" in development
		db:nil, # allocates a "table name" into which exceptions are saved (defaults to nil)
		email: "", # sends exception emails to a listed email (string // "you@email.com")

		  # Custom Exceptions
		  custom_exceptions: {
		    #'ActionController::RoutingError' => :not_found # => example
		  },

		  # On default 5xx error page, social media links included
		  social: {        
		    facebook: nil, # Facebook page name   
		    twitter:  nil, # Twitter handle  
		    youtube:  nil, # Youtube channel name / ID
		    linkedin: nil, # LinkedIn name
		    fusion:   nil  # FL Fusion handle
		  },  

		  # This is an entirely NEW structure for the "layouts" area
		  # You're able to define layouts, notifications etc ↴

		  # All keys interpolated as strings, so you can use symbols, strings or integers where necessary
		  exceptions: {

		    :all => {
		      layout: "application", # define layout
		      notification: false # (false by default)
		  # action: ____, (this is general)
		  # background: (can define custom background for exceptions layout if required)
		    },
		   
		    500 => {
		      layout: nil, # define layout
		      notification: false # (false by default)
		  # action: ____, (this is general)
		  # background: (can define custom background for exceptions layout if required)
		    }

		    # This is the old structure
		    # Still works but will be deprecated in future versions

		    # 501 => "exception",
		    # 502 => "exception",
		    # 503 => "exception",
		    # 504 => "exception",
		    # 505 => "exception",
		    # 507 => "exception",
		    # 510 => "exception"

		  }
		}

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
