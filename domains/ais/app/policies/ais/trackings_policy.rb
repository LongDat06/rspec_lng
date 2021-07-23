module Ais
  class TrackingsPolicy < ApplicationPolicy
    def index?
      user.role.admin? || user.role.user?
    end
  end
end
