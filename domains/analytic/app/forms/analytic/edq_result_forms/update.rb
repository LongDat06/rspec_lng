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
                                                         :laden_voyage_leg1,
                                                         :laden_voyage_leg2,
                                                         :ballast_voyage_leg1,
                                                         :ballast_voyage_leg2,
                                                         :author_id))
          assign_attributes_for_laden_voyage_leg1
          assign_attributes_for_ballast_voyage_leg1
          assign_attributes_for_laden_voyage_leg2
          assign_attributes_for_ballast_voyage_leg2
          edq_result.save!
        else
          raise(Validation, errors.full_messages.join(', '))
        end
      end

      private
        def edq_result
          @edq_result ||= Analytic::EdqResult.find(id)
        end

        def assign_attributes_for_laden_voyage_leg1
          return edq_result.laden_voyage_leg1&.destroy if laden_voyage_leg1.blank?

          if edq_result.laden_voyage_leg1&.persisted?
            edq_result.laden_voyage_leg1.assign_attributes(laden_voyage_leg1.attributes)
          else
            edq_result.build_laden_voyage_leg1(laden_voyage_leg1.attributes)
          end
        end

         def assign_attributes_for_laden_voyage_leg2
          return edq_result.laden_voyage_leg2&.destroy if laden_voyage_leg2.blank?

          if edq_result.laden_voyage_leg2&.persisted?
            edq_result.laden_voyage_leg2.assign_attributes(laden_voyage_leg2.attributes)
          else
            edq_result.build_laden_voyage_leg2(laden_voyage_leg2.attributes)
          end
        end

        def assign_attributes_for_ballast_voyage_leg1
          return edq_result.ballast_voyage_leg1&.destroy if ballast_voyage_leg1.blank?

          if edq_result.ballast_voyage_leg1&.persisted?
            edq_result.ballast_voyage_leg1.assign_attributes(ballast_voyage_leg1.attributes)
          else
            edq_result.build_ballast_voyage_leg1(ballast_voyage_leg1.attributes)
          end
        end

        def assign_attributes_for_ballast_voyage_leg2
          return edq_result.ballast_voyage_leg2&.destroy if ballast_voyage_leg2.blank?

          if edq_result.ballast_voyage_leg2&.persisted?
            edq_result.ballast_voyage_leg2.assign_attributes(ballast_voyage_leg2.attributes)
          else
            edq_result.build_ballast_voyage_leg2(ballast_voyage_leg2.attributes)
          end
        end
    end
  end
end
