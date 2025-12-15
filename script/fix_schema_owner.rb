#!/usr/bin/env ruby
require 'pg'

SUPERUSER = ENV['PG_SUPERUSER'] || 'postgres'
HOST = ENV['PG_HOST'] || '127.0.0.1'
TARGET_ROLE = ENV['PG_USERNAME'] || 'mosesa'

%w[taskflows_development taskflows_test].each do |db|
  begin
    conn = PG.connect(dbname: db, host: HOST, user: SUPERUSER)
    puts "Connected to #{db} as #{SUPERUSER}"
    %w[schema_migrations ar_internal_metadata].each do |tbl|
      conn.exec("ALTER TABLE IF EXISTS public.\"#{tbl}\" OWNER TO \"#{TARGET_ROLE}\"")
      conn.exec("GRANT ALL ON TABLE public.\"#{tbl}\" TO \"#{TARGET_ROLE}\"")
      puts "Changed owner and granted privileges for "+tbl+" in #{db} to #{TARGET_ROLE}"
    end
    conn.close
  rescue PG::Error => e
    STDERR.puts "Failed for #{db}: #{e.message}"
  end
end
