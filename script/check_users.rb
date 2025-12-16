#!/usr/bin/env ruby
# Script to check registered users in the database

require 'pg'

# Database configuration
DB_USER = ENV.fetch('PG_USERNAME', 'mosesa')
DB_PASSWORD = ENV.fetch('PG_PASSWORD', 'DanZiah132201$$')
DB_HOST = ENV.fetch('PG_HOST', '127.0.0.1')
DB_PORT = ENV.fetch('PG_PORT', 5432)
DB_NAME = 'taskflows_development'

begin
  conn = PG.connect(
    host: DB_HOST,
    port: DB_PORT,
    dbname: DB_NAME,
    user: DB_USER,
    password: DB_PASSWORD
  )

  puts "=" * 70
  puts "Registered Users in #{DB_NAME}"
  puts "=" * 70
  puts

  # Get user count
  count_result = conn.exec("SELECT COUNT(*) FROM users")
  total_users = count_result[0]['count'].to_i
  puts "Total Users: #{total_users}"
  puts

  if total_users > 0
    # Get all users
    users = conn.exec("SELECT id, email, created_at, updated_at FROM users ORDER BY id")

    puts "User Details:"
    puts "-" * 70
    users.each do |user|
      puts "ID:         #{user['id']}"
      puts "Email:      #{user['email']}"
      puts "Created At: #{user['created_at']}"
      puts "Updated At: #{user['updated_at']}"
      puts "-" * 70
    end
  else
    puts "No users found in the database."
  end

  conn.close

rescue PG::Error => e
  puts "Error connecting to database: #{e.message}"
end
