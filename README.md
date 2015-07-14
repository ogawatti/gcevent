[![Build Status](https://travis-ci.org/ogawatti/gcevent.svg?branch=master)](https://travis-ci.org/ogawatti/gcevent)
[![Coverage Status](https://coveralls.io/repos/ogawatti/gcevent/badge.png?branch=master)](https://coveralls.io/r/ogawatti/gcevent?branch=master)
[<img src="https://gemnasium.com/ogawatti/gcevent.png" />](https://gemnasium.com/ogawatti/gcevent)

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

```ruby
Google::Calendar.id                  = "Id of a target Google Calendar"
Google::Calendar.secret_key.path     = "Path of xxx-privatekey.p12"
Google::Calendar.secret_key.password = "Password"
Google::Calendar.client_id           = "ID of Client"
```

### Event#get

```ruby
event_id = "Google Calendar Event ID"
event = Google::Calendar::Event.get(event_id)
```

or

```ruby
event = Google::Calendar::Event.new(event_id: event_id)
event.fetch
```

### Event#list

specified date or time

```ruby
start_date = Date.today.beginning_of_week
end_date   = Date.today.end_of_week
events = Google::Calendar::Event.list(start_time, end_time)
```

today or this week or ...


```ruby
Google::Calendar::Event.today
Google::Calendar::Event.tomorrow
Google::Calendar::Event.yesterday
Google::Calendar::Event.this_week
Google::Calendar::Event.this_month
Google::Calendar::Event.this_year
```

### Event#insert

```ruby
event = Google::Calendar::Event.new
event.summary = "Inserted #{Time.now}"
event.start   = { dateTime: Date.today.to_time.utc.iso8601 }
event.end     = { dateTime: Date.tomorrow.to_time.utc.iso8601 }
event.insert
```

or

```ruby
options = { summary: "Inserted #{Time.now}",
start:   { date: Date.today },
end:     { date: Date.tomorrow } }
event = Google::Calendar::Event.insert(options)
```

### Event#quickAdd

quick insert

```ruby
text = "Quick Added"
event = Google::Calendar::Event.quickAdd(text)
```

### Event#update

```ruby
event = Google::Calendar::Event.this_week.last
event.summary = "Updated #{Time.now}"
event.update
```

# Delete Phase

```ruby
event = Google::Calendar::Event.this_week.first
event.delete
```

or

```ruby
event = Google::Calendar::Event.this_week.last
Google::Calendar::Event.delete(event.id)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/gcevent/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
