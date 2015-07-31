require 'spec_helper'
require 'pry'

describe Google::Calendar::Event do

  let(:event_instance_variables) { [ :id, :kind, :etag, :status, :htmlLink, :created, :updated, 
                                     :creator, :organizer, :transparency, :iCalUID, :sequence, :reminders,
                                     :summary, :start, :end ] }
  let(:calendar_id) { "aaaaaaaaaaaaaaaaaaaaaaaaaa@group.calendar.google.com" }
  let(:client_id)   { "1000000000000-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.apps.googleusercontent.com" }
  let(:client_execute_options) { { api_method:  api_method,
                                   parameters:  parameters,
                                   body:        body,
                                   headers:     { 'Content-Type' => 'application/json' } } }
  let(:test_data)  { { kind:         "calendar#event",
                       etag:         "\"1000000000000000\"",
                       id:           id,
                       status:       "confirmed",
                       htmlLink:     "https://www.google.com/calendar/event?eid=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                       created:      "2015-07-07T00:00:00.000Z",
                       updated:      "2015-07-07T01:00:00.000Z",
                       summary:      summary,
                       creator:      { email: "testuser@gmail.com", displayName: "testuser" },
                       organizer:    { email: calendar_id,  displayName: "testcalendar", self: true },
                       start:        start_date,
                       end:          end_date,
                       transparency: "transparent",
                       iCalUID:      id + "@google.com",
                       sequence:     0,
                       reminders:    { useDefault: true } } }
  let(:id) { "aaaaaaaaaaaaaaaaaaaaaaaaaa" }
  let(:summary)    { "Test Event" }
  let(:start_date) { { date: Date.today } }
  let(:end_date)   { { date: Date.tomorrow } }

  before do
    allow(Google::APIClient::KeyUtils).to receive(:load_key) { OpenSSL::PKey::RSA.new }
    allow(File).to receive(:exist?) { true }
    allow_any_instance_of(Signet::OAuth2::Client).to receive(:fetch_access_token!) { true }
    Google::Calendar.client_id = client_id
    Google::Calendar.id = calendar_id
    allow(Google::Calendar).to receive(:authorize?) { true }
  end

  describe '#initialize' do
    context 'without otpion' do
      it 'should be instance of Google::Calendar::Event' do
        event = Google::Calendar::Event.new
        expect(event).to be_instance_of Google::Calendar::Event
        event_instance_variables.each{|name| expect(event.send(name)).to be_nil }
      end
    end

    context 'with all otpion' do
      let(:options) { { summary: summary, start: { date: Date.today }, end: { date: Date.tomorrow } } }

      it 'should be instance of Google::Calendar::Event' do
        event = Google::Calendar::Event.new(options)
        expect(event).to be_instance_of Google::Calendar::Event
        event_instance_variables.each do |name|
          case name
          when :summary
            expect(event.send(name)).to eq options[name]
          when :start, :end
            expect(event.send(name).date).to eq options[name][:date]
          else
            expect(event.send(name)).to be_nil
          end
        end
      end
    end
  end

  # [API] get
  #   GET /calendars/:calendarId/events/eventId
  describe 'GET /calendars/:calendarId/events/eventId' do
    let(:event)      { Google::Calendar::Event.new(options) }
    let(:options)    { { id: id, summary: summary, start: start_date, end: end_date } }

    let(:api_method) { Google::Calendar.api.events.get }
    let(:parameters) { { calendarId: calendar_id, eventId: id } }
    let(:body)       { "" }

    let(:response)   { Hashie::Mash.new( { status: status, data: data } ) } 
    let(:status)     { 200 }
    let(:data)       { test_data }

    before do
      expect_any_instance_of(Google::APIClient).to receive(:execute!).with(client_execute_options) { response }
    end

    describe '.get' do
      it 'should be instance of Google::Calendar::Event' do
        event = Google::Calendar::Event.get(id)
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end

    describe '#fetch' do
      it 'should be instance of Google::Calendar::Event' do
        event.fetch
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end
  end

  # [API] list
  #   GET /calendars/:calendarId/events
  describe 'GET /calendars/:calendarId/events' do
    let(:api_method) { Google::Calendar.api.events.list }
    let(:parameters) { { calendarId: calendar_id,
                         orderBy:    'startTime',
                         timeMax:    end_time.to_time.utc.iso8601,
                         timeMin:    start_time.to_time.utc.iso8601,
                         singleEvents: 'True' } }
    let(:body)       { "" }

    let(:response)   { Hashie::Mash.new( { status: status, data: data } ) }
    let(:status)     { 200 }
    let(:data)       { { items: [ test_data ] } }

    let(:start_time) { Date.today.beginning_of_week }
    let(:end_time)   { Date.today.end_of_week }

    describe '.list' do
      before do
        expect_any_instance_of(Google::APIClient).to receive(:execute!).with(client_execute_options) { response }
      end

      it 'should be instance of Google::Calendar::Event' do
        events = Google::Calendar::Event.list(start_time, end_time)
        expect(events.size).to eq 1
        event = events.first
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end

    shared_examples 'Called Event.list and Recieve Start and End' do
      before { expect(Google::Calendar::Event).to receive(:list).with(start_time, end_time) }
      it { is_expected.not_to raise_error }
    end

    describe '.today' do
      let(:start_time) { Date.today }
      let(:end_time)   { Date.tomorrow }
      subject { lambda { Google::Calendar::Event.today } }
      it_behaves_like 'Called Event.list and Recieve Start and End'
    end

    describe '.tomorrow' do
      let(:start_time) { Date.tomorrow }
      let(:end_time)   { Date.tomorrow.tomorrow }
      subject { lambda { Google::Calendar::Event.tomorrow } }
      it_behaves_like 'Called Event.list and Recieve Start and End'
    end

    describe '.yesterday' do
      let(:start_time) { Date.yesterday }
      let(:end_time)   { Date.today }
      subject { lambda { Google::Calendar::Event.yesterday } }
      it_behaves_like 'Called Event.list and Recieve Start and End'
    end

    describe '.this_week' do
      let(:start_time) { Date.today.beginning_of_week }
      let(:end_time)   { Date.today.end_of_week }
      subject { lambda { Google::Calendar::Event.this_week } }
      it_behaves_like 'Called Event.list and Recieve Start and End'
    end

    describe '.this_month' do
      let(:start_time) { Date.today.beginning_of_month }
      let(:end_time)   { Date.today.end_of_month }
      subject { lambda { Google::Calendar::Event.this_month } }
      it_behaves_like 'Called Event.list and Recieve Start and End'
    end

    describe '.this_year' do
      let(:start_time) { Date.today.beginning_of_year }
      let(:end_time)   { Date.today.end_of_year }
      subject { lambda { Google::Calendar::Event.this_year } }
      it_behaves_like 'Called Event.list and Recieve Start and End'
    end
  end

  # [API] insert
  #   POST /calendars/:calendarId/events
  describe 'POST /calendars/:calendarId/events' do
    let(:event)      { Google::Calendar::Event.new(options) }
    let(:options)    { { summary: summary, start: start_date, end: end_date } }

    let(:api_method) { Google::Calendar.api.events.insert }
    let(:parameters) { { calendarId: calendar_id } }
    let(:body)       { event.to_json }

    let(:response)   { Hashie::Mash.new( { status: status, data: test_data } ) } 
    let(:status)     { 200 }
    let(:data)       { test_data }

    before do
      expect_any_instance_of(Google::APIClient).to receive(:execute!).with(client_execute_options) { response }
    end

    describe '#insert' do
      it 'should be instance of Google::Calendar::Event' do
        event.insert
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end

    describe '.insert' do
      it 'should be instance of Google::Calendar::Event' do
        event = Google::Calendar::Event.insert(options)
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end
  end

  # [API] delete
  #   DELETE /calendars/:calendarId/events/:eventId
  describe 'DELETE /calendars/:calendarId/events/:eventId' do
    let(:event)      { Google::Calendar::Event.new(options) }
    let(:options)    { { id: id, summary: summary, start: start_date, end: end_date } }

    let(:api_method) { Google::Calendar.api.events.delete }
    let(:parameters) { { calendarId: calendar_id, eventId: id } }
    let(:body)       { "" }

    let(:response)   { Hashie::Mash.new( { status: status, data: test_data } ) } 
    let(:status)     { 204 }
    let(:data)       { nil }

    before do
      allow_any_instance_of(Google::Calendar::Event).to receive(:fetch) { event }
      expect_any_instance_of(Google::APIClient).to receive(:execute!).with(client_execute_options) { response }
    end

    describe '#delete' do
      it 'should be instance of Google::Calendar::Event' do
        event.delete
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end

    describe '.delete' do
      it 'should be instance of Google::Calendar::Event' do
        event = Google::Calendar::Event.delete(id)
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end
  end

  # [API] quickAdd
  #   POST /calendars/:calendarId/events/quickAdd
  describe 'POST /calendars/:calendarId/events/quickAdd' do
    let(:event)      { Google::Calendar::Event.new(options) }
    let(:options)    { { summary: summary, start: start_date, end: end_date } }

    let(:api_method) { Google::Calendar.api.events.quick_add }
    let(:parameters) { { calendarId: calendar_id, text: summary } }
    let(:body)       { "" }

    let(:response)   { Hashie::Mash.new( { status: status, data: test_data } ) } 
    let(:status)     { 200 }
    let(:data)       { test_data }

    before do
      expect_any_instance_of(Google::APIClient).to receive(:execute!).with(client_execute_options) { response }
    end

    describe '#quickAdd' do
      it 'should be instance of Google::Calendar::Event' do
        event = Google::Calendar::Event.quickAdd(summary)
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end
  end

  # [API] update
  #   PUT /calendars/:calendarId/events/:eventId
  describe 'PUT /calendars/:calendarId/events/:eventId' do
    let(:event)      { Google::Calendar::Event.new(options) }
    let(:options)    { { id: id, summary: summary, start: start_date, end: end_date } }

    let(:api_method) { Google::Calendar.api.events.update }
    let(:parameters) { { calendarId: calendar_id, eventId: id } }
    let(:body)       { event.to_json }

    let(:response)   { Hashie::Mash.new( { status: status, data: test_data } ) } 
    let(:status)     { 200 }
    let(:data)       { test_data }

    before do
      expect_any_instance_of(Google::APIClient).to receive(:execute!).with(client_execute_options) { response }
    end

    describe '#update' do
      it 'should be instance of Google::Calendar::Event' do
        event.update
        expect(event.summary).to eq summary
        expect(event).to be_instance_of Google::Calendar::Event
        expect_event_to_eq_test_data(event, test_data)
      end
    end
  end

  describe '#num_of_days' do
    let(:event)      { Google::Calendar::Event.new(options) }
    let(:options)    { { summary: summary, start: start_date, end: end_date } }

    # num_of_days : today ~ tomorrow
    subject { event.num_of_days }
    it { is_expected.to eq 2 }
  end

  def expect_event_to_eq_test_data(event, test_data)
    test_data.each_key do |key|
      case key
      when :creator, :organizer
       expect(event.send(key).email).to       eq test_data[key][:email]
        expect(event.send(key).displayName).to eq test_data[key][:displayName]
        expect(event.send(key).self).to        eq test_data[key][:self] if key == :organizer
      when :start, :end
        expect(event.send(key).date).to        eq test_data[key][:date]
      when :reminders
        expect(event.send(key).useDefault).to  eq test_data[key][:useDefault]
      else
        expect(event.send(key)).to             eq test_data[key]
      end
    end
  end
end
