module Weather
  class WelcomeController < ApplicationController
    def index
      render json: { 'message': 'wellcome to AIS'}
    end
  end
end
