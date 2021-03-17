module Ais
  module Ecdis
    class Import
      ECDIS_PROCESSOR = {
        Furuno: Ais::Ecdis::FurunoProcessor,
        JRC: Ais::Ecdis::JrcProcessor
      }
      
      def initialize(received_at:, filepath:, filename:, vessel:)
        @received_at = received_at
        @filepath = filepath
        @filename = filename
        @vessel = vessel
      end

      def call 
        ECDIS_PROCESSOR[correct_type.to_sym].new(
          received_at: @received_at,
          filepath: @filepath,
          filename: @filename,
          vessel: @vessel
        ).call
      end

      private
      def correct_type
        File.open(@filepath, &:gets).include?('// ROUTE SHEET exported by JRC ECDIS.') ? 'JRC' : 'Furuno'
      end
    end
  end
end
