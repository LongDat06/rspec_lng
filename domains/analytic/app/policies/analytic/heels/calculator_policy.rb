module Analytic
  module Heels
    class CalculatorPolicy < ApplicationPolicy

      def create?
        admin_or_user?
      end

    end
  end
end
