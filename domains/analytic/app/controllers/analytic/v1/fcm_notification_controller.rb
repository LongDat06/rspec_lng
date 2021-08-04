module Analytic
  module V1
    class FcmNotificationController < BaseController
      def subcribe
        response = fcm_service.subcribe(fcm_notifcation_params[:device_token])
        json_response({}, response[:status_code])
      end

      def unsubcribed
        response = fcm_service.unsubcribed(fcm_notifcation_params[:device_token])
        json_response({}, response[:status_code])
      end

      private
      def fcm_notifcation_params
        params.permit(:device_token, :topic)
      end

      def fcm_service
        @fcm_service ||= Analytic::FirebaseCM::Fcm.new(fcm_notifcation_params[:topic])
      end
    end
  end
end
