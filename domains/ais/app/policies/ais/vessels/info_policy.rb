module Ais
  module Vessels
    class InfoPolicy < ApplicationPolicy
      def index?
        user.role.admin? || user.role.user?
      end
    end
  end
end
