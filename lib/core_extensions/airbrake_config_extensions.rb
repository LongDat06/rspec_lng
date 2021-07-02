module CoreExtensions
  module AirbrakeConfigExtensions
   	
    # Monkey patch from airbrake-ruby v2.5 they remove passing project key through query parameter https://github.com/airbrake/airbrake-ruby/pull/278/files
    # Errbit version 0.7.0 still need it for authentication.
    def error_endpoint
      @error_endpoint ||=
        begin
          self.error_host = ('https://' << error_host) if error_host !~ %r{\Ahttps?://}
          api = "api/v3/projects/#{project_id}/notices?key=#{project_key}"
          URI.join(error_host, api)
        end
    end
  end
end

module Airbrake
  class Config
     prepend ::CoreExtensions::AirbrakeConfigExtensions
  end
end
