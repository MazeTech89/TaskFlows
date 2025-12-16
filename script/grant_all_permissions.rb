#!/usr/bin/env ruby
# Script to grant full permissions to mosesa role on all databases and tables

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

def database_exists?(db_name)
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

def grant_database_permissions(db_name)
  return unless database_exists?(db_name)
  
  puts "\nGranting permissions for database: #{db_name}"
  
  # Connect to the specific database
  conn = PG.connect(
    host: DB_HOST,
    port: DB_PORT,
    dbname: db_name,
    user: DB_USER,
    password: DB_PASSWORD
  )
  
  begin
    # Grant all privileges on database
    conn.exec("GRANT ALL PRIVILEGES ON DATABASE #{db_name} TO #{DB_USER}")
    puts "  ✓ Granted ALL PRIVILEGES on database"
    
    # Get all tables in public schema
    tables = conn.exec(
      "SELECT tablename FROM pg_tables WHERE schemaname = 'public'"
    )
    
    if tables.ntuples > 0
      # Grant all privileges on all tables
      conn.exec("GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO #{DB_USER}")
      puts "  ✓ Granted ALL PRIVILEGES on all tables"
      
      # Alter owner for all tables
      tables.each do |row|
        table_name = row['tablename']
        conn.exec("ALTER TABLE #{table_name} OWNER TO #{DB_USER}")
        puts "    ✓ Changed owner of #{table_name} to #{DB_USER}"
      end
      
      # Grant all privileges on all sequences
      conn.exec("GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO #{DB_USER}")
      puts "  ✓ Granted ALL PRIVILEGES on all sequences"
      
      # Alter owner for all sequences
      sequences = conn.exec(
        "SELECT sequencename FROM pg_sequences WHERE schemaname = 'public'"
      )
      sequences.each do |row|
        seq_name = row['sequencename']
        conn.exec("ALTER SEQUENCE #{seq_name} OWNER TO #{DB_USER}")
        puts "    ✓ Changed owner of sequence #{seq_name} to #{DB_USER}"
      end
    else
      puts "  ℹ No tables found in database"
    end
    
    # Grant default privileges for future objects
    conn.exec("ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO #{DB_USER}")
    conn.exec("ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO #{DB_USER}")
    puts "  ✓ Set default privileges for future objects"
    
  rescue PG::Error => e
    puts "  ✗ Error: #{e.message}"
  ensure
    conn.close
  end
end

puts "=" * 70
puts "Granting Full Permissions to User: #{DB_USER}"
puts "=" * 70

DATABASES.each do |db_name|
  if database_exists?(db_name)
    grant_database_permissions(db_name)
  else
    puts "\n✗ Database #{db_name} does not exist - skipping"
  end
end

puts "\n" + "=" * 70
puts "Permission Grant Complete"
puts "=" * 70
puts "\nRun script/check_db_permissions.rb to verify changes."
