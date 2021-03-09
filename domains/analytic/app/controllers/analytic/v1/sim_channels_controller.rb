module Analytic
  module V1
    class SimChannelsController < BaseController
      CHANNEL_PER_PAGE = 50

      def index
        scope = Analytic::SimServices::Channels.new(
          params: channel_params
        ).()

        pagy, channels = pagy_mongoid(scope, items: CHANNEL_PER_PAGE)
        json_channels = Analytic::V1::SimChannelSerializer.new(channels).serializable_hash
        pagy_headers_merge(pagy)
        json_response(json_channels)
      end

      private
      def channel_params
        params.permit(:local_name)
      end
    end
  end
end