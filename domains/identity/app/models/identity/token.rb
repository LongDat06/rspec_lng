module Identity
  class Token < ApplicationRecord
    self.table_name = 'tokens'
    
    validates_presence_of :crypted_token
  end
end
