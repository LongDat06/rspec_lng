module Analytic
  module V1
    module Downloads
      class TemplatesController < BaseController
        def index
          templates = Analytic::DownloadTemplate
            .readable(current_user.id)
            .order_by('created_at' => -1)
          json_templates = Analytic::V1::DownloadTemplateSerializer.new(templates).serializable_hash
          json_response(json_templates)
        end

        def create
          template = Analytic::DownloadTemplate.new(template_params)
          template.author_id = current_user.id
          unless template.valid?
            raise(
              StandardError, 
              template.errors.full_messages.to_sentence
            )
          end
          template.save!
          json_response({})
        end

        def destroy
          template = Analytic::DownloadTemplate.find(params[:id])
          template.destroy!
          json_response({})
        end

        private
        def template_params
          params.permit(:imo_no, :name, :shared, channels: [])
        end
      end
    end
  end
end
