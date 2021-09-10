module Ais
  module Validations
    class Tracking
      include ActiveModel::Validations

      attr_accessor :from_time, :to_time, :imos

      validates_presence_of :imos

      def initialize(params)
        @from_time = params[:from_time]
        @to_time = params[:to_time]
        @imos = params[:imos]
      end
    end
  end
end
