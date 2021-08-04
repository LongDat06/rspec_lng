module Analytic
  module FirebaseCM
    class Fcm
      require 'fcm'

      attr_reader :topic

      def initialize(topic)
        @topic = topic
      end


      def send device_token, notification
        notification = set_notification(notification)
        fcm.send(devices_token(device_token), notification)
      end

      def send_to_topic notification
        notification = set_notification(notification)
        fcm.send_to_topic(topic, notification)
      end

      def subcribe device_token
        fcm.batch_topic_subscription(topic, devices_token(device_token))
      end

      def unsubcribed device_token
        fcm.batch_topic_unsubscription(topic, devices_token(device_token))
      end

      private

      def fcm
        @fcm ||= FCM.new(ENV['FCM_SERVER_KEY'])
      end

      def devices_token device_token
        @devices_token ||= [device_token]
      end

      def notification_title
        "New notification".freeze
      end

      def notification_body
        "New notification Message!".freeze
      end

      def set_notification notification
        { 
          notification: {
            title: notification[:title] || notification_title,
            body: notification[:body] || notification_body
          }
        }
      end

    end
  end
end
