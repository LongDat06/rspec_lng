# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins *ENV['ALLOW_CORS_DOMAIN'].split(',')

    # Only allow a request for a specific host
    resource '*',
        headers: :any,
        :methods => [:get, :post, :delete, :put, :patch, :options, :head], expose: ['ETag', 'Link'],
        :credentials => true
  end

  allow do
    origins '*'

    resource '/cors',
             :headers => :any,
             :methods => [:post]

    resource '*',
             :headers => :any,
             :methods => [:get, :post, :delete, :put, :patch, :options, :head]
  end
end
