module Analytic
  module SimServices
    class Channels
      def initialize(params:)
        @local_name = params[:local_name]
        @imo_no = params[:imo]
        @unit = params[:unit]
        @channels = params[:channels]
        @except_channels = params[:except_channels]
      end

      def call
        channel_data
      end

      private
      def channel_data
        scope = Analytic::SimChannel
          .where(imo_no: @imo_no)
          .where(:local_name.nin => ["", nil])
          .unit(@unit)

        scope = scope.where(:_id.in => @channels) if @channels.present?
        scope = scope.where(:_id.nin => @except_channels) if @except_channels.present?
        scope = scope.full_text_search(@local_name, match: :all) if @local_name.present?
        scope.order('standard_name' => 1)
      end
    end
  end
end
