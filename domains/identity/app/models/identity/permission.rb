module Identity
  class Permission < ApplicationRecord
    self.table_name = 'permissions'

    belongs_to :user
    belongs_to :role

    validates_presence_of :user_id, :role_id
  end
end
