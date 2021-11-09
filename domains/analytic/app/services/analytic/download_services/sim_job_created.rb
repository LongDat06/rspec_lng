module Analytic
  module DownloadServices
    class SimJobCreated
      def initialize(params:, current_user_id:)
        @params = params
        @current_user_id = current_user_id
      end

      def call
        download = Analytic::Download.new(
          author_id: @current_user_id,
          imo_no: imos[0],
          source: :sim,
          created_at: Time.current,
        )
        download.condition = build_condition
        download.save!
        download
      end

      private
      def imos
        return [] if @params[:imos].blank?
        @params[:imos].uniq
      end

      def build_condition
        @build_condition ||= begin
          {
            timestamp_from_at: @params[:timestamp_from_at],
            timestamp_to_at: @params[:timestamp_to_at],
            columns: @params[:column_mappings].to_h,
            included_stdname: @params[:included_stdname]
          }
        end
      end
    end
  end
end
