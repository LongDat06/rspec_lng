module Ais
  class PlanRoutesPolicy < ApplicationPolicy
    def index?
      user.role.admin? || user.role.user?
    end
  end
end
