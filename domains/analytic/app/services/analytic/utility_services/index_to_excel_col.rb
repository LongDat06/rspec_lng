module Analytic
  module UtilityServices
    class IndexToExcelCol
      # Number starting based on mapping
      # For example: 
      ## 7 mapping => 'F' then int will decrease -1
      ## 7 mapping => 'H' then int will increase +1
      ## 7 mapping => 'G' then int will increase +0
      def self.convert(int)
        name = 'A'
        (int - 1).times { name.succ! }
        name
      end
    end
  end
end
