module AutoBooker
  class NubApp
    def initialize(username, password, application_id)
      @username = username
      @password = password
      @application_id = application_id
    end

    def get_slots(from_date, to_date, category_activity_id)
      login unless logged_in?

      parameters = {
        'id_category_activity' => category_activity_id,
        'offset' => '-120',
        'start' => from_date.to_time.to_i.to_s,
        'end' => to_date.to_time.to_i.to_s,
        '_' => DateTime.now.to_time.to_i.to_s,
      }

      response = agent.get('https://sport.nubapp.com/web/ajax/activities/getActivitiesCalendar.php', parameters)
      raise "Could not get slots - Response #{response.inspect}" unless response.body

      slots = JSON.parse(response.body)
      raise "Could not get slots - Response #{response.inspect}" unless slots.is_a?(Array)

      slots.map do |slot_object|
        Slot.from_json(slot_object)
      end
    end

    def book(slot_id)
      form_value = [
        "items[activities][0][id_activity_calendar]=#{slot_id}",
        'items[activities][0][unit_price]=0',
        'items[activities][0][n_guests]=0',
        'items[activities][0][id_resource]=false',
        'discount_code=false',
        'form=',
        'formIntoNotes='
      ].join('&')

      response = agent.post("https://sport.nubapp.com/web/ajax/bookings/bookBookings.php", form_value, {'content-type' => 'application/x-www-form-urlencoded'})
      unless response.body && JSON.parse(response.body)["error"] = 0
        raise "Could not book slot #{slot_id} - Response #{response.inspect}"
      end

      true
    end

    private

    def agent
      @agent ||= Mechanize.new do |agent|
        agent.user_agent_alias = 'Mac Safari'
      end
    end

    def login
      return if logged_in?

      agent.get("https://sport.nubapp.com/web/setApplication.php?id_application=#{application_id}")
      agent.get("https://sport.nubapp.com/web/cookieChecker.php?id_application=#{application_id}&isIframe=false")

      form_value = Mechanize::Util.build_query_string(
        'username' => username, 
        'password' => password,
      )

      response = agent.post("https://sport.nubapp.com/web/ajax/users/checkUser.php", form_value, {'content-type' => 'application/x-www-form-urlencoded'})

      unless response.body && JSON.parse(response.body)["success"]
        raise "Could not login - Response = #{response.inspect}"
      end

      logged_in!
    end

    def logged_in?
      @logged_in
    end

    def logged_in!
      @logged_in = true
    end

    attr_reader :username
    attr_reader :password
    attr_reader :application_id
  end
end