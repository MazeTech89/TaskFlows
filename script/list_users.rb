puts "\nTotal users: #{User.count}\n\n"
User.all.each do |user|
  puts "ID: #{user.id}"
  puts "Email: #{user.email}"
  puts "Created: #{user.created_at}"
  puts "---"
end
