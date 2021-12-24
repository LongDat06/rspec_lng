module Analytic
  module EdqServices
    class FinalizationError < StandardError; end
    class Finalization

      def initialize(edq_result: )
        @edq_result = edq_result
      end

      def call
        Analytic::EdqResult.transaction do
          @edq_result.finalized = true
          unfinalized_old_edqs
          @edq_result.save!
        end
      rescue => e
        raise FinalizationError, e.message
      end

      def unfinalized_old_edqs
        scope = Analytic::EdqResult.where(imo: @edq_result.imo, finalized: true)
        if @edq_result.laden_voyage_no.present? &&  @edq_result.ballast_voyage_no.present?
          scope = scope.where("laden_voyage_no = :laden_voyage_no OR ballast_voyage_no = :ballast_voyage_no",
                              laden_voyage_no: @edq_result.laden_voyage_no, ballast_voyage_no: @edq_result.ballast_voyage_no)
        else
          scope = scope.where(laden_voyage_no: @edq_result.laden_voyage_no) if @edq_result.laden_voyage_no.present?
          scope = scope.where(ballast_voyage_no: @edq_result.ballast_voyage_no) if @edq_result.ballast_voyage_no.present?
        end
        scope.update_all(finalized: false)
      end

    end
  end
end
