#!/usr/bin/env ruby
# Verifies that the configured PG_SUPERUSER exists and has superuser privileges
require 'pg'

su = ENV['PG_SUPERUSER'] || 'postgres'
host = ENV['PG_HOST'] || '127.0.0.1'

begin
  conn = PG.connect(host: host, user: su)
  puts "PG_SUPERUSER=#{su} (connecting to #{host})"
  
  # Check if role exists and has superuser flag
  res = conn.exec_params('SELECT rolname, rolsuper FROM pg_roles WHERE rolname = $1', [su])
  
  if res.ntuples == 1
    row = res[0]
    puts "role=#{row['rolname']}, rolsuper=#{row['rolsuper']}"
  else
    puts "role '#{su}' not found in pg_roles"
  end
  
  conn.close
rescue PG::Error => e
  STDERR.puts "PG error: #{e.message}"
  exit 1
end
