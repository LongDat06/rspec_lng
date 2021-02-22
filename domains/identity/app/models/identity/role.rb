module Identity
  class Role < ApplicationRecord
    self.table_name = 'roles'

    has_many :permissions
    has_many :users, through: :permissions
    
    validates_presence_of :name
  end
end
