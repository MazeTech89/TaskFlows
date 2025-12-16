# User model - authentication via Devise, owns projects and tasks
class User < ApplicationRecord
  # Devise modules for authentication and account management
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations: user owns projects, has tasks through projects
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects
  
  # Email must exist and be unique (case-insensitive)
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
