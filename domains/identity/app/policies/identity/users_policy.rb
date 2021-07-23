module Identity
  class UsersPolicy < ApplicationPolicy
    def index?
      user.role.admin?
    end

    def create?
      user.role.admin?
    end

    def update?
      user.role.admin?
    end

    def destroy?
      user.role.admin? && user.id != record.id
    end
  end
end
