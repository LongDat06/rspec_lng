module Identity
  class MePolicy < ApplicationPolicy
    def index?
      true
    end
  end
end
