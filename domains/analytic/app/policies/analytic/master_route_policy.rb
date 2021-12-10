module Analytic
  class MasterRoutePolicy < ApplicationPolicy
    def index?
      admin?
    end

    def create?
      admin?
    end

    def update?
      admin?
    end

    def destroy?
      admin?
    end
  end
end
