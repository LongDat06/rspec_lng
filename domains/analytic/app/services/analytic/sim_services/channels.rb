module Analytic
  module SimServices
    class Channels
      def initialize(params:)
        @local_name = params[:local_name]
        @imo_no = params[:imo]
      end

      def call
        channel_data
      end

      private
      def channel_data
        scope = Analytic::SimChannel
          .where(imo_no: @imo_no)
          .where(:local_name.nin => ["", nil])
        scope = scope.full_text_search(@local_name, match: :all) if @local_name.present?
        scope.order('standard_name' => 1) 
      end
    end
  end
end
