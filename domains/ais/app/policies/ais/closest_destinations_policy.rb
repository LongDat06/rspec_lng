module Ais
  class ClosestDestinationsPolicy < ApplicationPolicy
    def index?
      user.role.admin? || user.role.user?
    end
  end
end
