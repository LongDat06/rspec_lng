module Ais
  class WelcomeController < ApplicationController
    def index
      render json: { 'message': 'wellcome to AIS'}
    end
  end
end
