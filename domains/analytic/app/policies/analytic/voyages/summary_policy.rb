module Analytic
  module Voyages
    class SummaryPolicy < ApplicationPolicy
      def index?
        admin_or_user?
      end

      def show?
        admin_or_user?
      end

      def export?
        admin_or_user?
      end

      def update_manual_fields?
        admin?
      end
    end
  end
end
