user = User.find_or_initialize_by(email: "admin@taskflows.com")
user.password = "password123"
user.password_confirmation = "password123"
user.save!

puts "Test user created!"
puts "Email: admin@taskflows.com"
puts "Password: password123"
