module Analytic
  module V1
    class SettingSerializer
      include FastJsonapi::ObjectSerializer

      attributes :code
      attribute :value do |object, params|
        if object.value.present?
          params[:value_type].present? ?
                    method(params[:value_type]).call(object.value) : object.value
        end

      end



    end
  end
end
