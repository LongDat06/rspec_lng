module Analytic
  module SimJob
    class ImportingJob < ApplicationJob
      queue_as :importing_job

      def perform
        Analytic::SimServices::Importing::ImportProcessing.new(dmg_sakura).()
        Analytic::SimServices::Importing::ImportProcessing.new(dmg_orchid).()
        Analytic::SimServices::Importing::ImportProcessing.new(dmg_metropolis).()
      end

      private

      def dmg_sakura #9810020
        {
          metadata_path: "/Users/admin/Desktop/sim/ShipData_9810020_Metadata_S2332_r3.xlsx",
          data_path: "/Users/admin/Desktop/sim/IoSData_98100202020122310420455.xlsx"
        }
      end

      def dmg_orchid #9779226
        {
          metadata_path: "/Users/admin/Desktop/sim/ShipData_9779226_Metadata_S2324_r7.xlsx",
          data_path: "/Users/admin/Desktop/sim/IoSData_97792262020110100331748.xlsx"
        }
      end

      def dmg_metropolis #9862487
        {
          metadata_path: "/Users/admin/Desktop/sim/ShipData_9862487_Metadata_r8.xlsx",
          data_path: "/Users/admin/Desktop/sim/IoSData_98624872021011719114459.xlsx"
        }
      end

    end
  end
end
