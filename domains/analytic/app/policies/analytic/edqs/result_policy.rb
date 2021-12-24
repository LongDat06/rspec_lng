module Analytic
  module Edqs
    class ResultPolicy < ApplicationPolicy

      def index?
        admin_or_user?
      end

      def create?
        admin_or_user?
      end

      def update?
        admin_or_user?
      end

      def show?
        admin_or_user?
      end

      def destroy?
        admin_or_user?
      end

      def finalize?
        admin_or_user?
      end

    end
  end
end
