module Analytic
  module V1
    module Downloads
      class TemplatesControllerInvalidParameters < ActionController::BadRequest; end
      class TemplatesController < BaseController
        before_action :validate_params, only: [:create]

        def index
          authorize Analytic::DownloadTemplate

          templates = Analytic::DownloadTemplate
            .readable(current_user.id)
            .order_by('created_at' => -1)
          json_templates = Analytic::V1::DownloadTemplateSerializer.new(templates).serializable_hash
          json_response(json_templates)
        end

        def create
          authorize Analytic::DownloadTemplate

          template = Analytic::DownloadTemplate.new(create_template_params)
          unless template.valid?
            raise(
              StandardError,
              template.errors.full_messages.to_sentence
            )
          end
          template.save!
          json_response({})
        end

        def update
          template = Analytic::DownloadTemplate.find(params[:id])
          authorize template

          template.update!(update_template_params)
          json_response({})
        end

        def destroy
          template = Analytic::DownloadTemplate.find(params[:id])
          authorize template
          template.destroy!
          json_response({})
        end

        private
        def create_template_params
          permitted = params.permit(:imo_no, :name, :shared)
          permitted.merge!({channels: fetch_channels, author_id: current_user.id, latest_updated_by_id: current_user.id})
          permitted
        end

        def update_template_params
          {channels: fetch_channels, latest_updated_by_id: current_user.id}
        end

        def validate_params
          template_download_validation = Analytic::Validations::Download::Templates.new(create_template_params)
          unless template_download_validation.valid?
            raise(
              TemplatesControllerInvalidParameters,
              template_download_validation.errors.full_messages.to_sentence
            )
          end
        end

        def fetch_channels
          Analytic::SimServices::Channels.new(
            params: {
              imo: params[:imo_no],
              channels: params[:is_select_all].to_s == 'true' ? nil : params[:channels],
              except_channels: params[:except_channels]
            }
          ).call.each_with_object({}) { |sim, hash| hash[sim.id.to_s] = sim.local_name }
        end

      end
    end
  end
end
