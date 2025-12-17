user = User.find_by(id: 1)
if user
  puts "User ID 1:"
  puts "Email: #{user.email}"
  puts "Created: #{user.created_at}"
  puts "Updated: #{user.updated_at}"
else
  puts "NO - User with ID 1 not found"
end
