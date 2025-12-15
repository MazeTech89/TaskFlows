class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
