module Analytic
  module Validations
    class SimDownload
      include ActiveModel::Validations

      attr_accessor :imos, :timestamp_from_at, :timestamp_to_at, :column_mappings

      validates_presence_of :imos, :column_mappings
      validates :timestamp_from_at, :timestamp_to_at, presence: true
      validate :end_date_after_start_date

      def initialize(params)
        @timestamp_from_at = params[:timestamp_from_at]
        @timestamp_to_at = params[:timestamp_to_at]
        @imos = params[:imos]
        @column_mappings = params[:column_mappings]
      end

      private
      def end_date_after_start_date
        return if timestamp_to_at.blank? || timestamp_from_at.blank?
        if timestamp_to_at.to_datetime < timestamp_from_at.to_datetime
          errors.add(:timestamp_to_at, I18n.t('analytic.end_date_after_start_date'))
        end
      end
    end
  end
end
