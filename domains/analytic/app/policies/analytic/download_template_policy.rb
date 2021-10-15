module Analytic
  class DownloadTemplatePolicy < ApplicationPolicy

    def index?
      admin_or_user?
    end

    def update?
      record.ownable?(user.id) || (user.role.admin? && record.public?)
    end

    def edit?
      admin_or_user?
    end

    def create?
      admin_or_user?
    end

    def destroy?
      record.ownable?(user.id) || (user.role.admin? && record.public?)
    end

  end
end
