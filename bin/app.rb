#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'auto_booker'

username = ENV.fetch('NUBAPP_USERNAME')
password = ENV.fetch('NUBAPP_PASSWORD')
activity_id = ENV.fetch('NUBAPP_ACTIVITY_ID')
activity_category_id = ENV.fetch('NUBAPP_ACTIVITY_CATEGORY_ID')

if ARGV.size != 2
  $stderr.puts "Usage: bin/app.rb <preference_file.yml> <already_booked.yml>"
  $stderr.puts "preference.yml has to describe the slots you want"
  $stderr.puts "already_booked.yml is just a save file and doesn't have to be created"
  exit(1)
end

preference_file = ARGV[0]
already_booked_file = ARGV[1]

AutoBooker.auto_book(
  username: ENV.fetch('NUBAPP_USERNAME'),
  password: ENV.fetch('NUBAPP_PASSWORD'),
  activity_id: ENV.fetch('NUBAPP_ACTIVITY_ID'),
  activity_category_id: ENV.fetch('NUBAPP_ACTIVITY_CATEGORY_ID'),
  preferences_file: preference_file,
  already_booked_file: already_booked_file,
)
