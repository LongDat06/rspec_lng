module Identity
  module V1
    class UserSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :fullname, :email, :role
    end
  end
end
