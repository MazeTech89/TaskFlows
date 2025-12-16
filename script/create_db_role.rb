#!/usr/bin/env ruby
require 'pg'

SUPERUSER = ENV['PG_SUPERUSER'] || 'postgres'
HOST = ENV['PG_HOST'] || '127.0.0.1'

begin
  conn = PG.connect(host: HOST, user: SUPERUSER)
  puts "Connected to Postgres at #{HOST} as #{SUPERUSER}"

  # Create role if missing
  res = conn.exec_params("SELECT 1 FROM pg_roles WHERE rolname=$1", [ 'mosesa' ])
  if res.ntuples == 0
    conn.exec("CREATE ROLE mosesa LOGIN PASSWORD 'TECHmomo4life01'")
    conn.exec("ALTER ROLE mosesa CREATEDB")
    puts "Created role 'mosesa' with CREATEDB"
  else
    puts "Role 'mosesa' already exists"
  end

  %w[taskflows_development taskflows_test].each do |db|
    res = conn.exec_params("SELECT 1 FROM pg_database WHERE datname=$1", [ db ])
    if res.ntuples == 0
      conn.exec("CREATE DATABASE #{db} OWNER mosesa")
      puts "Created database #{db} owned by mosesa"
    else
      puts "Database #{db} already exists"
    end
  end

  conn.close
  puts "Done."
rescue PG::Error => e
  STDERR.puts "PG error: #{e.message}"
  STDERR.puts e.backtrace.join("\n")
  exit 1
end
