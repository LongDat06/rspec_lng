module Shared
  class User < ApplicationRecord
    self.table_name = 'users'

    extend Enumerize

    enumerize :role, in: { admin: 0, user: 1 }
  end
end
