# frozen_string_literal: true

module YourModule
  class Engine < Rails::Engine
    # => ExceptionHandler
    # => Works in and out of an initializer
    config.exception_handler = {
      dev: nil, # => this will not load the gem in development
      db: true # => this will use the :errors table to store exceptions
    }
  end
end
