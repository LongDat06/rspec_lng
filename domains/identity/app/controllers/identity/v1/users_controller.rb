module Identity
  module V1
    class UsersController < BaseController
      USER_PER_PAGE = 20

      def create
        authorize User, policy_class: Identity::UsersPolicy
        user = User.create!(user_params)
        user_jsons = Identity::V1::UserSerializer.new(user).serializable_hash
        json_response(user_jsons)
      end

      def index
        authorize User, policy_class: Identity::UsersPolicy
        page_number = (params[:page] || 1).to_i
        pagy, users = pagy(User.order(created_at: :desc), items: USER_PER_PAGE)
        users_json = Identity::V1::UserSerializer.new(users).serializable_hash
        pagy_headers_merge(pagy)
        json_response(users_json)
      end

      def update
        user = User.find(params[:id])
        authorize user, policy_class: Identity::UsersPolicy
        user.update!(user_params)
        json_response({})
      end

      def destroy
        user = User.find(params[:id])
        authorize user, policy_class: Identity::UsersPolicy
        user.destroy!
        json_response({})
      end

      private
      def user_params
        params.permit(:role, :fullname, :email, :password, :password_confirmation)
      end
    end
  end
end
