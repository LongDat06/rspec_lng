module Analytic
  module EdqResultForms
    class Validation < StandardError; end
    class Creation < Base
      include ActiveModel::Validations
      include Virtus.model

      validates_presence_of  :author_id

      def save!
        if valid?
          edq_result.assign_attributes(attributes.except(:laden_voyage, :ballast_voyage))
          edq_result.build_laden_voyage(laden_voyage.attributes) if laden_voyage.present?
          edq_result.build_ballast_voyage(ballast_voyage.attributes) if ballast_voyage.present?
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
