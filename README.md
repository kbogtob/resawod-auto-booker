# resawod-auto-booker

This project was implemented out of frustration of forgetting to subscribe to gym classes on resawod.

It allows specifying preferences of classes you want to join and it will subscribe to them.


### Running the App

```bash
bundle install
bundle exec bin/app.rb preferences.yml already_booked.yml
```

Here is the usage transcript:
```
Usage: bin/app.rb <preference_file.yml> <already_booked.yml>
preference.yml has to describe the slots you want
already_booked.yml is just a save file and doesn't have to be created
```

The app will then look at the slots available and book them automatically according to the defined preferences.

Booked slots will be saved inside the already_booked.yml file so that they don't get booked again. This allows unsubscribing manually from slots and not automatically subscribing to them again.

### Credentials

The app requires the following environment variables (`sample.env`):
* `NUBAPP_USERNAME`: Your username on the Resawod application
* `NUBAPP_PASSWORD`: Your password on the Resawod application
* `NUBAPP_ACTIVITY_ID`: The activity identifier of your Gym (Box)
* `NUBAPP_ACTIVITY_CATEGORY_ID`: The calendar of your Gym (Box)

I'll see if I implement a helper tool to get the activity id and the activity category id. In the mean time, you can just go your Resawod application, login and then go to your Gym calendar, you should find the two parameters named exactly the same in your devtools.

### Preferences file

```yml
- weekday: 'Tuesday' # weekday of the class you want to join
  hour: 12           # hour of the class you want to join
  minutes: 30        # minutes of the class you want to join
- weekday: 'Thursday'
  hour: 12
  minutes: 30
- weekday: 'Friday'
  hour: 12
  minutes: 15
- weekday: 'Saturday'
  hour: 9
  minutes: 0
```

###
