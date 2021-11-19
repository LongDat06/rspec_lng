module Analytic
  module EdqResultForms
    class Validation < StandardError; end
    class Update < Base

      attribute :id, Integer

      def save!
        if valid?
          edq_result.assign_attributes(attributes.except(:id,
                                                         :imo,
                                                         :laden_voyage_no,
                                                         :ballast_voyage_no,
                                                         :laden_voyage,
                                                         :ballast_voyage,
                                                         :author_id))
          assign_attributes_for_laden_voyage
          assign_attributes_for_ballast_voyage
          edq_result.save!
        else
          raise(Validation, errors.full_messages.join(', '))
        end
      end

      private
        def edq_result
          @edq_result ||= Analytic::EdqResult.find(id)
        end

        def assign_attributes_for_laden_voyage
          return edq_result.laden_voyage&.destroy if laden_voyage.blank?

          if edq_result.laden_voyage&.persisted?
            edq_result.laden_voyage.assign_attributes(laden_voyage.attributes)
          else
            edq_result.build_laden_voyage(laden_voyage.attributes)
          end
        end

        def assign_attributes_for_ballast_voyage
          return edq_result.ballast_voyage&.destroy if ballast_voyage.blank?

          if edq_result.ballast_voyage&.persisted?
            edq_result.ballast_voyage.assign_attributes(ballast_voyage.attributes)
          else
            edq_result.build_ballast_voyage(ballast_voyage.attributes)
          end
        end
    end
  end
end
