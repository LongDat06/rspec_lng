require 'rails_helper'
require_relative '/Users/admin/Documents/lng-backend/domains/analytic/spec/support/controller_macros'

RSpec.describe "FocControllers", type: :request do
  # byebug
  before :each do
    login_user
  end

  describe "GET /index" do
    it "index" do
      # expect(response).to be_successful
      puts "dsadasdasd"
    end
  end
end
