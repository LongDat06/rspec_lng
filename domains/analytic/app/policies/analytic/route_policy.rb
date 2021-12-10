module Analytic
  class RoutePolicy < ApplicationPolicy
    def index?
      admin?
    end

    def update?
      admin?
    end

    def show?
      admin?
    end

    def create?
      admin?
    end

    def destroy?
      admin?
    end

    def import?
      admin?
    end

    def fetch_invalid_record_file?
      admin?
    end

    def export?
      admin?
    end
  end
end