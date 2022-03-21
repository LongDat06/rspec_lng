require 'rails_helper'

RSpec.describe "FocControllers", type: :request do
  describe 'POST /login' do
    let(:user) { FactoryBot.create(:user, email: 'dat.huynh@dounets.com', password: '123456') }
    it 'authenticates the user' do
      post '/identity/v1/auth', params: {  email: 'dat.huynh@dounets.com', password: '123456'}
      expect(response).to have_http_status(:created)
      expect(json).to eq({
                           'id' => user.id,
                           'email' => 'dat.huynh@dounets.com',
                           'token' => AuthenticationTokenService.call(user.id)
                         })
    end


  end
end
