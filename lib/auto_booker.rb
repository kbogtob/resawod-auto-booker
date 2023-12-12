require 'mechanize'
require 'cgi'
require 'byebug'
require 'json'
require 'date'
require 'set'
require 'pathname'

require_relative 'auto-booker/slot'
require_relative 'auto-booker/booking'
require_relative 'auto-booker/booking_manager'
require_relative 'auto-booker/preference'
require_relative 'auto-booker/preferences_loader'
require_relative 'auto-booker/nub_app'
require_relative 'auto-booker/booker'

module AutoBooker
  def self.auto_book(username:, password:, activity_id:, activity_category_id:, preferences_file:, already_booked_file:)
    booking_manager = BookingManager.new(already_booked_file)
    
    already_booked = booking_manager.load_bookings

    booker = Booker::new(
      nub_app: AutoBooker::NubApp.new(username, password, activity_id), 
      preferences: PreferencesLeoader.from_yaml_file(preferences_file), 
      activity_category_id: activity_category_id,
      already_booked: already_booked,
    )
    
    booker.run(dryrun: true)

    new_booked = booker.already_booked

    booking_manager.save(new_booked)
  end
end