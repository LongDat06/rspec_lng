require 'rails_helper'

module Analytic
  RSpec.describe VoyageSummary, type: :model do  
    describe "Validations" do
      subject { FactoryBot.create :analytic_voyage_summaries }
      
      it "is valid with valid attributes" do
        byebug
          is_expected.to be_valid
      end
    end
  end
end
