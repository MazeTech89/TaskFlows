require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:tasks).through(:projects) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }

    it 'validates uniqueness of email (case insensitive)' do
      User.create!(email: "test@example.com", password: "password123")
      user2 = User.new(email: "TEST@example.com", password: "password123")
      expect(user2).not_to be_valid
    end
  end

  describe 'Devise modules' do
    it 'has database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'has registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'has recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'has rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'has validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end
  end
end
