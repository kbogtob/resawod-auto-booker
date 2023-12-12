module AutoBooker
  class Booking < Struct.new(:activity_id, :start_time)
    def self.from_yaml(yaml)
      Booking.new(yaml['activity_id'], Time.at(yaml['start_time']))
    end

    def to_yaml
      {
        'activity_id' => activity_id,
        'start_time' => start_time.to_i,
      }
    end
  end
end