module Ais
  class VesselsPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user.role.admin?
          scope.all
        else
          scope.where(target: false)
        end
      end
    end

    def index?
      user.role.admin? || user.role.user?
    end

    def create?
      user.role.admin?
    end

    def update?
      user.role.admin? || user.role.user?
    end

    def destroy?
      user.role.admin? || user.role.user?
    end
  end
end
