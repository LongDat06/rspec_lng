module Shared
  class User < ApplicationRecord
    self.table_name = 'users'

    extend Enumerize

    enumerize :role, in: { admin: 0, user: 1 }

    has_many :reports, class_name: Analytic::ReportFile.name, foreign_key: :user_id
  end
end
