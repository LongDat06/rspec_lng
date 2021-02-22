module Identity
  module V1
    class UserSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :fullname, :email
    end
  end
end
