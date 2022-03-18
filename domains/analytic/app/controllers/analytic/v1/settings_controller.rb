module Analytic
  module V1
    class SettingsController < BaseController

      def get_lng_consumption_in_panama
        authorize nil, policy_class: Analytic::SettingPolicy
        setting = Analytic::Setting.find_or_create_by(code: Analytic::Setting::LNG_CONSUMPTION_IN_PANAMA_CODE)
        serializable_hash = Analytic::V1::SettingSerializer.new(setting, params: { value_type: :Float }).serializable_hash
        json_response(serializable_hash)
      end

      def update_lng_consumption_in_panama
        authorize nil, policy_class: Analytic::SettingPolicy
        setting = Analytic::Setting.find_or_initialize_by(code: Analytic::Setting::LNG_CONSUMPTION_IN_PANAMA_CODE)
        setting.value = Float(params[:value])
        setting.save!
        json_response({})
      end

    end
  end
end
