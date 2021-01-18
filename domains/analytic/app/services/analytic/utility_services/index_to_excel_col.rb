module Analytic
  module UtilityServices
    class IndexToExcelCol
      # Number starting from 1
      def self.convert(int)
        name = 'A'
        (int - 2).times { name.succ! }
        name
      end
    end
  end
end
