module AutoBooker
  class BookingManager
    def initialize(bookings_path)
      @bookings_path = Pathname.new(bookings_path)
      
      @bookings_path.write(YAML.dump([])) unless @bookings_path.exist?
    end

    def load_bookings
      bookings_yaml = YAML.load_file(bookings_path)

      bookings_yaml.map do |booking_yaml|
        Booking.from_yaml(booking_yaml)
      end
    end

    def save(bookings)
      yaml = bookings.map do |booking|
        booking.to_yaml
      end

      bookings_path.write(YAML.dump(yaml))
    end

    private
    attr_reader :bookings_path
  end
end