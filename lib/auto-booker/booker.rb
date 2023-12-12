module AutoBooker
  class Booker
    def initialize(nub_app:, preferences:, activity_category_id:, already_booked: [])
      @nub_app = nub_app
      @preferences = preferences
      @activity_category_id = activity_category_id
      @already_booked = Set.new(already_booked)
    end

    def run(dryrun: false)
      slots = fetch_available_slots
      
      candidate_slots = slots.filter do |slot|
        should_book?(slot)
      end

      candidate_slots.each do |candidate_slot|
        if booked_slot = book_slot(candidate_slot, dryrun: dryrun)
          already_booked.add(booked_slot.to_booking)
        end
      end

      true
    end

    attr_reader :already_booked

    private

    def fetch_available_slots
      now = DateTime.now
      in_7_days = now + 7

      nub_app.get_slots(now, in_7_days, activity_category_id)
    end

    attr_reader :nub_app
    attr_reader :preferences
    attr_reader :activity_category_id

    def should_book?(slot)
      return false unless slot.joinable?

      return false unless preferences.any? do |preference|
        preference.match?(slot)
      end

      ! already_booked.include?(slot.to_booking)
    end

    def book_slot(slot, dryrun:)
      if dryrun
        puts "Would have booked #{slot.inspect}"
      else
        nub_app.book(slot.activity_id)
        puts "Booked #{slot.inspect}"
      end

      slot
    rescue StandardError => e
      puts "Could not book #{slot} - #{e}"
      nil
    end
  end
end