# Gcevent

A wrapper of Google Calendar Event API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gcevent'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gcevent

## Usage

### Calendar Setting

    Google::Calendar.id                  = "Id of a target Google Calendar"
    Google::Calendar.secret_key.path     = "Path of xxx-privatekey.p12"
    Google::Calendar.secret_key.password = "Password"
    Google::Calendar.client_id           = "ID of Client"

### Event#get

    event_id = "Google Calendar Event ID"
    event = Google::Calendar::Event.get(event_id)

or

    event = Google::Calendar::Event.new(event_id: event_id)
    event.fetch

### Event#list

specified date or time

    start_date = Date.today.beginning_of_week
    end_date   = Date.today.end_of_week
    events = Google::Calendar::Event.list(start_time, end_time)

today or this week or ...

    events = Google::Calendar::Event.today
    events = Google::Calendar::Event.tomorrow
    events = Google::Calendar::Event.yesterday
    events = Google::Calendar::Event.this_week
    events = Google::Calendar::Event.this_month
    events = Google::Calendar::Event.this_year

### Event#insert

    event = Google::Calendar::Event.new
    event.summary = "Inserted #{Time.now}"
    event.start   = { dateTime: Date.today.to_time.utc.iso8601 }
    event.end     = { dateTime: Date.tomorrow.to_time.utc.iso8601 }
    event = event.insert

or

    options = { summary: "Inserted #{Time.now}",
                start:   { date: Date.today },
                end:     { date: Date.tomorrow } }
    event = Google::Calendar::Event.insert(options)

### Event#quickAdd

quick insert

    text = "Quick Added"
    event = Google::Calendar::Event.quickAdd(text)

### Event#update

    event = Google::Calendar::Event.this_week.last
    event.summary = "Updated #{Time.now}"
    event.update

# Delete Phase

    event = Google::Calendar::Event.this_week.first
    event.delete

or

    event = Google::Calendar::Event.this_week.last
    Google::Calendar::Event.delete(event.id)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gcevent/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
