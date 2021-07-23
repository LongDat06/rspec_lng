module Ais
  module Vessels
    class NonTargetsPolicy < ApplicationPolicy
      def create?
        user.role.admin? || user.role.user?
      end
    end
  end
end
