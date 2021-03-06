require 'hashie'
require 'active_support'
require 'active_support/core_ext'

module Google
  module Calendar
    class Event
      # API Reference
      #  * https://developers.google.com/google-apps/calendar/v3/reference/#Events
      #
      # Supported Google Calendar API (Events)
      #   Method    VERB    PATH
      #   --------  ------  --------------------------------------
      #   get       GET     /calendars/:calendarId/events/:eventId
      #   list      GET     /calendars/:calendarId/events
      #   insert    POST    /calendars/:calendarId/events
      #   delete    DELETE  /calendars/:calendarId/events/:eventId
      #   quickAdd  POST    /calendars/:calendarId/events/quickAdd
      #   update    PUT     /calendars/:calendarId/events/:eventId

      attr_reader   :id, :kind, :etag, :status, :htmlLink, :created, :updated
      attr_reader   :creator, :organizer, :transparency, :iCalUID, :sequence, :reminders
      attr_accessor :summary, :start, :end
      def initialize(options={})
        update_attributes(options)
      end

      # [API] get
      #   GET /calendars/:calendarId/events/eventId
      def self.get(id)
        self.new(id: id).fetch
      end

      def fetch
        params  = { calendarId: Calendar.id, eventId: id }
        request(Calendar.api.events.get, params)
      end

      # [API] list
      #   GET /calendars/:calendarId/events
      def self.list(st, et)
        params = { calendarId:   Calendar.id,
                   orderBy:      'startTime',
                   timeMax:      et.to_time.utc.iso8601,
                   timeMin:      st.to_time.utc.iso8601,
                   singleEvents: 'True' }
        request(Calendar.api.events.list, params)
      end

      # [API] insert
      #   POST /calendars/:calendarId/events
      def insert
        params = { calendarId: Calendar.id }
        body   = self.to_json
        request(Calendar.api.events.insert, params, body)
      end

      def self.insert(options={})
        self.new(options).insert
      end

      # [API] delete
      #   DELETE /calendars/:calendarId/events/:eventId
      def delete
        params  = { calendarId: Calendar.id, eventId: id }
        request(Calendar.api.events.delete, params)
        self
      end

      def self.delete(id)
        self.new(id: id).fetch.delete
      end

      # [API] quickAdd
      #   POST /calendars/:calendarId/events/quickAdd
      def self.quickAdd(text)
        params = { calendarId: Calendar.id, text: text }
        request(Calendar.api.events.quick_add, params)
      end

      # [API] update
      #   PUT /calendars/:calendarId/events/:eventId
      def update
        params = { calendarId: Calendar.id, eventId: id }
        body = self.to_json
        request(Calendar.api.events.update, params, body)
        self
      end

      def to_hash
        self.instance_variables.inject(Hashie::Mash.new) do |hash, name|
          key = name.to_s.delete("@").to_sym
          hash[key] = self.instance_variable_get(name)
          hash
        end
      end

      def to_json
        self.to_hash.to_json
      end

      def num_of_days
        start_date = (self.start.date || self.start.dateTime).to_date
        end_date   = (self.end.date   || self.end.dateTime  ).to_date
        (end_date - start_date).to_i + 1
      end

      def self.today
        start_time = Date.today
        end_time   = Date.tomorrow
        list(start_time, end_time)
      end

      def self.tomorrow
        start_time = Date.tomorrow
        end_time   = Date.tomorrow.tomorrow
        list(start_time, end_time)
      end

      def self.yesterday
        start_time = Date.yesterday
        end_time   = Date.today
        list(start_time, end_time)
      end

      def self.this_week
        start_time = Date.today.beginning_of_week
        end_time   = Date.today.end_of_week
        list(start_time, end_time)
      end

      def self.this_month
        start_time = Date.today.beginning_of_month
        end_time   = Date.today.end_of_month
        list(start_time, end_time)
      end

      def self.this_year
        start_time = Date.today.beginning_of_year
        end_time   = Date.today.end_of_year
        list(start_time, end_time)
      end

      private

      def update_attributes(options={})
        opts = Hashie::Mash.new(options)
        opts.each do |key, value|
          instance_variable_set("@#{key}".to_sym, value) if respond_to?(key)
        end
      end

      def request(api_method, params={}, body="")
        data = self.class.execute(api_method, params, body)
        if data.respond_to?(:to_hash)
          update_attributes(data.to_hash)
        elsif data.nil?
          {}
        else
          raise data.to_s
        end
        self
      end

      def self.request(api_method, params={}, body="")
        data = execute(api_method, params, body)
        if data.respond_to?(:items)
          data_to_events(data.items)
        elsif data.respond_to?(:to_hash)
          data_to_event(data)
        else
          raise data.to_s
        end
      end

      def self.execute(api_method, params={}, body="")
        response = Calendar.execute(api_method, params, body)
        response.data
      end
      
      def self.data_to_event(event_data)
        self.new(event_data.to_hash)
      end

      def self.data_to_events(events_data)
        events_data.inject([]) do |events, event_data|
          events << data_to_event(event_data)
        end
      end
    end
  end
end
