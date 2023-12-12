module AutoBooker
  class Slot
    def initialize(activity_id:, title:, start_time:, end_time:, subscribed:, joinable:)
      @activity_id = activity_id
      @title = title
      @start_time = start_time
      @end_time = end_time
      @subscribed = subscribed
      @joinable = joinable
    end
  
    attr_reader :activity_id
    attr_reader :title
    attr_reader :start_time
    attr_reader :end_time
    attr_reader :subscribed
    attr_reader :joinable

    def match?(day, hour, minutes)
      start_to_time = start_time.to_time

      day == Date::DAYNAMES[start_to_time.wday] &&
        hour == start_to_time.hour && 
        minutes == start_to_time.min
    end

    def joinable?
      @joinable
    end

    def self.from_json(json_object)
      Slot.new(
        activity_id: json_object.fetch("id_activity_calendar"),
        title: json_object.fetch("title"),
        start_time: DateTime.parse(json_object.fetch("start_timestamp")),
        end_time: DateTime.parse(json_object.fetch("end_timestamp")),
        subscribed: json_object.fetch("inscribed") == 1,
        joinable: json_object.fetch("user_info").fetch("can_join"),
      )
    end

    def to_booking
      Booking.new(activity_id, start_time.to_time)
    end
  end
end