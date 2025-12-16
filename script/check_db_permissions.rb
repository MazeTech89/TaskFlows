#!/usr/bin/env ruby
# Script to check and display database permissions for mosesa role

require 'pg'

# Database configuration
DB_USER = ENV.fetch('PG_USERNAME', 'mosesa')
DB_PASSWORD = ENV.fetch('PG_PASSWORD', 'DanZiah132201$$')
DB_HOST = ENV.fetch('PG_HOST', '127.0.0.1')
DB_PORT = ENV.fetch('PG_PORT', 5432)

# List of all databases from database.yml
DATABASES = [
  'taskflows_development',
  'taskflows_test',
  'taskflows_production',
  'taskflows_cache_production',
  'taskflows_queue_production',
  'taskflows_cable_production'
]

def check_database_exists(db_name)
  conn = PG.connect(
    host: DB_HOST,
    port: DB_PORT,
    dbname: 'postgres',
    user: DB_USER,
    password: DB_PASSWORD
  )
  
  result = conn.exec_params(
    "SELECT 1 FROM pg_database WHERE datname = $1",
    [db_name]
  )
  
  exists = result.ntuples > 0
  conn.close
  exists
rescue PG::Error => e
  puts "Error checking database #{db_name}: #{e.message}"
  false
end

def check_database_owner(db_name)
  conn = PG.connect(
    host: DB_HOST,
    port: DB_PORT,
    dbname: 'postgres',
    user: DB_USER,
    password: DB_PASSWORD
  )
  
  result = conn.exec_params(
    "SELECT pg_catalog.pg_get_userbyid(d.datdba) AS owner 
     FROM pg_catalog.pg_database d 
     WHERE d.datname = $1",
    [db_name]
  )
  
  owner = result[0]['owner'] if result.ntuples > 0
  conn.close
  owner
rescue PG::Error => e
  puts "Error checking owner for #{db_name}: #{e.message}"
  nil
end

def check_table_permissions(db_name)
  return unless check_database_exists(db_name)
  
  conn = PG.connect(
    host: DB_HOST,
    port: DB_PORT,
    dbname: db_name,
    user: DB_USER,
    password: DB_PASSWORD
  )
  
  # Get all tables in public schema
  tables = conn.exec(
    "SELECT tablename FROM pg_tables WHERE schemaname = 'public'"
  )
  
  permissions = {}
  tables.each do |row|
    table_name = row['tablename']
    
    # Check table owner
    owner_result = conn.exec_params(
      "SELECT tableowner FROM pg_tables WHERE schemaname = 'public' AND tablename = $1",
      [table_name]
    )
    
    permissions[table_name] = {
      owner: owner_result[0]['tableowner'],
      privileges: []
    }
    
    # Check privileges
    priv_result = conn.exec_params(
      "SELECT privilege_type 
       FROM information_schema.table_privileges 
       WHERE table_schema = 'public' 
       AND table_name = $1 
       AND grantee = $2",
      [table_name, DB_USER]
    )
    
    priv_result.each do |priv|
      permissions[table_name][:privileges] << priv['privilege_type']
    end
  end
  
  conn.close
  permissions
rescue PG::Error => e
  puts "Error checking permissions for #{db_name}: #{e.message}"
  {}
end

puts "=" * 70
puts "Database Permissions Report for User: #{DB_USER}"
puts "=" * 70
puts

DATABASES.each do |db_name|
  puts "\n--- Database: #{db_name} ---"
  
  if check_database_exists(db_name)
    puts "✓ Database exists"
    
    owner = check_database_owner(db_name)
    if owner == DB_USER
      puts "✓ Owner: #{owner} (CORRECT)"
    else
      puts "✗ Owner: #{owner} (SHOULD BE #{DB_USER})"
    end
    
    permissions = check_table_permissions(db_name)
    
    if permissions.empty?
      puts "  No tables found or unable to check permissions"
    else
      puts "\n  Tables:"
      permissions.each do |table, info|
        owner_status = info[:owner] == DB_USER ? "✓" : "✗"
        puts "    #{owner_status} #{table}"
        puts "      Owner: #{info[:owner]}"
        puts "      Privileges: #{info[:privileges].join(', ')}"
      end
    end
  else
    puts "✗ Database does not exist"
  end
end

puts "\n" + "=" * 70
puts "End of Report"
puts "=" * 70
