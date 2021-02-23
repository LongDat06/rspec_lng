module Identity
  module V1
    class UsersController < BaseController
      USER_PER_PAGE = 20

      def create
        User.create!(user_params)
        json_response({})
      end

      def index
        page_number = (params[:page] || 1).to_i
        pagy, users = pagy(User.order(created_at: :desc), items: USER_PER_PAGE)
        users_json = Identity::V1::UserSerializer.new(users).serializable_hash
        pagy_headers_merge(pagy)
        json_response(users_json)
      end

      def update
        user = User.find(params[:id])
        user.update!(user_params)
        json_response({})
      end

      def destroy
        user = User.find(params[:id])
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
