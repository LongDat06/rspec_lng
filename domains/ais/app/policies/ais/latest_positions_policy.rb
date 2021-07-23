module Ais
  class LatestPositionsPolicy < ApplicationPolicy
    def index?
      user.role.admin? || user.role.user?
    end
  end
end
