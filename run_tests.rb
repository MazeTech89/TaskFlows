#!/usr/bin/env ruby
# Simple test runner to verify RSpec works

puts "\n" + "="*60
puts "Running TaskFlow Test Suite"
puts "="*60 + "\n"

# Run model tests
puts "\n### MODEL TESTS ###\n"
system("bundle exec rspec spec/models --format documentation --no-color")

puts "\n### TEST SUMMARY ###"
system("bundle exec rspec spec/models --format progress")
