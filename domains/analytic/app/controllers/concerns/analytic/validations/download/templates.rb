module Analytic
  module Validations
    module Download
      class Templates
        include ActiveModel::Validations

        attr_accessor :imo_no, :name, :shared, :channels, :author_id

        validates_presence_of :imo_no, :name, :shared, :channels
        validate :uniqueness_of_name

        def initialize(params)
          @imo_no = params[:imo_no]
          @name = params[:name]
          @shared = params[:shared]
          @channels = params[:channels]
          @author_id = params[:author_id]
        end

        private
        def uniqueness_of_name
          if Analytic::DownloadTemplate.where(name: name, author_id: author_id, shared: :local).exists? ||
            Analytic::DownloadTemplate.where(name: name, shared: :public).exists?
            errors.add(:name, :taken)
          end
        end
      end
    end
  end
end
