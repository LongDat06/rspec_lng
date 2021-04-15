module Analytic
  module Validations
    module Download
      class Templates
        include ActiveModel::Validations

        attr_accessor :imo_no, :name, :shared, :channels

        validates_presence_of :imo_no, :name, :shared, :channels
        validate :uniqueness_of_name

        def initialize(params)
          @imo_no = params[:imo_no]
          @name = params[:name]
          @shared = params[:shared]
          @channels = params[:channels]
        end

        private
        def uniqueness_of_name
          if Analytic::DownloadTemplate.where(name: name).exists?
            errors.add(:name, :taken)
          end
        end
      end
    end
  end
end
