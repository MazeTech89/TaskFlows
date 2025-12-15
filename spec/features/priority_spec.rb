require 'rails_helper'

RSpec.describe Priority, type: :model do
  it "is valid with a unique name" do
    priority = Priority.new(name: "High")
    expect(priority).to be_valid
  end

  it "is invalid without a name" do
    priority = Priority.new(name: nil)
    expect(priority).not_to be_valid
  end
end
