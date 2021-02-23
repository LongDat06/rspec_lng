module Identity
  class User < ApplicationRecord
    self.table_name = 'users'

    extend Enumerize
    
    has_secure_password
    cattr_accessor :current_user

    enumerize :role, in: { admin: 0, user: 1 }

    has_many :permissions
    has_many :roles, through: :permissions

    validates :email, presence: true, email: true, uniqueness: { case_sensitive: true }
    validates_presence_of :fullname, :password_digest, :role
    validates :email, presence: true, uniqueness: { case_sensitive: true }
    validates_presence_of :password_confirmation, :if => :password_digest_changed?
  end
end
