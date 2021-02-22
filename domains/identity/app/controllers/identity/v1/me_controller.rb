module Identity
  module V1
    class MeController < BaseController
      def index
        authorize current_user, policy_class: MePolicy
        user_jsons = Identity::V1::MeSerializer.new(current_user).serializable_hash
        json_response(user_jsons)
      end
    end
  end
end
