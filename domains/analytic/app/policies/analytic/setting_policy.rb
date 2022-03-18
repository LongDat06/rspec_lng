module Analytic
  class SettingPolicy < ApplicationPolicy
    def get_lng_consumption_in_panama?
      admin_or_user?
    end

    def update_lng_consumption_in_panama?
      admin?
    end

  end
end
