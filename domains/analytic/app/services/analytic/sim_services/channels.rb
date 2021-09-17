module Analytic
  module SimServices
    class Channels
      def initialize(params:)
        @local_name = params[:local_name]
        @imo_no = params[:imo]
        @unit = params[:unit]
        @channels = params[:channels]
        @sort_by = params[:sort_by]
        @sort_order = params[:sort_order]
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
        scope.order(order_params)
      end

      def order_params
        default = { sort_by_parser => sort_order_parser }
      end

      def sort_by_parser
        allow_sort_fields = { 'channel' => 'local_name', 'unit' => 'unit' }
        allow_sort_fields.fetch(@sort_by, 'standard_name')
      end

      def sort_order_parser
        @sort_order == "desc" ? -1 : 1
      end
    end
  end
end
