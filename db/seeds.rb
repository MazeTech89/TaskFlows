# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default priorities
puts "Creating priorities..."
Priority.find_or_create_by!(name: "Low") do |p|
  p.score = 1.0
end

Priority.find_or_create_by!(name: "Medium") do |p|
  p.score = 3.0
end

Priority.find_or_create_by!(name: "High") do |p|
  p.score = 5.0
end

Priority.find_or_create_by!(name: "Critical") do |p|
  p.score = 10.0
end

puts "Created #{Priority.count} priorities"
