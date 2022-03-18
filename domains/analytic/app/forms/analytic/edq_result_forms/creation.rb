module Analytic
  module EdqResultForms
    class Validation < StandardError; end
    class Creation < Base
      include ActiveModel::Validations
      include Virtus.model

      validates_presence_of  :author_id

      def save!
        if valid?
          edq_result.assign_attributes(attributes.except(:laden_voyage_leg1,
                                                         :ballast_voyage_leg1,
                                                         :laden_voyage_leg2,
                                                         :ballast_voyage_leg2))
          edq_result.build_laden_voyage_leg1(laden_voyage_leg1.attributes) if laden_voyage_leg1.present?
          edq_result.build_ballast_voyage_leg1(ballast_voyage_leg1.attributes) if ballast_voyage_leg1.present?
          edq_result.build_laden_voyage_leg2(laden_voyage_leg2.attributes) if laden_voyage_leg2.present?
          edq_result.build_ballast_voyage_leg2(ballast_voyage_leg2.attributes) if ballast_voyage_leg2.present?
          edq_result.save!
        else
          raise(Validation, errors.full_messages.join(', '))
        end
      end

      private
        def edq_result
          @edq_result ||= Analytic::EdqResult.new
        end
    end
  end
end
