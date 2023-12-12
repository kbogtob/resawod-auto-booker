module AutoBooker
  class Preference
    def initialize(weekday:, hour:, minutes:)
      @weekday = weekday
      @hour = hour
      @minutes = minutes
    end

    attr_reader :weekday
    attr_reader :hour
    attr_reader :minutes

    def match?(slot)
      slot.match?(weekday, hour, minutes)
    end
  end
end