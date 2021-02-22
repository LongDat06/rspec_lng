module Identity
  module V1
    class MeSerializer
      include FastJsonapi::ObjectSerializer

      attributes :id, :fullname, :email, :role
    end
  end
end
