# Test script to verify OmniauthRequest functionality
require_relative '../../config/environment'

puts "Testing OmniauthRequest model..."

begin
  # Test 1: Check if OmniauthRequest.last works
  result = OmniauthRequest.last
  puts "Test 1 - OmniauthRequest.last: #{result.inspect}"

  # Test 2: Create a new valid record
  new_request = OmniauthRequest.new(
    provider: "google_oauth2",
    email: "test@example.com"
  )

  if new_request.save
    puts "Test 2 - Created new record: #{new_request.inspect}"

    # Test 3: Check expired? method
    puts "Test 3 - Is expired? #{new_request.expired?}"

    # Test 4: Mark as expired
    new_request.mark_as_expired!
    puts "Test 4 - After marking as expired: #{new_request.inspect}"
    puts "Test 4 - Is expired now? #{new_request.expired?}"

    # Clean up
    new_request.destroy
    puts "Cleaned up test record"
  else
    puts "Test 2 - Failed to create record: #{new_request.errors.full_messages.join(', ')}"
  end

  # Test 5: Validation for invalid email
  invalid_request = OmniauthRequest.new(
    provider: "google_oauth2",
    email: "invalid-email"
  )

  if invalid_request.save
    puts "Test 5 - Created invalid record (unexpected): #{invalid_request.inspect}"
    invalid_request.destroy
  else
    puts "Test 5 - Validation correctly failed: #{invalid_request.errors.full_messages.join(', ')}"
  end

  puts "All tests completed"
rescue => e
  puts "Error: #{e.message}"
  puts e.backtrace.join("\n")
end
