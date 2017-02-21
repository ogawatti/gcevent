require 'spec_helper'

describe Google::Calendar do
  let(:id)        { "aaaaaaaaaaaaaaaaaaaaaaaaaa@group.calendar.google.com" }
  let(:client_id) { "1000000000000-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.apps.googleusercontent.com" }
  let(:event_id)  { "aaaaaaaaaaaaaaaaaaaaaaaaaa" }

  before do
    allow(Google::APIClient::KeyUtils).to receive(:load_key) { OpenSSL::PKey::RSA.new }
    allow(File).to receive(:exist?) { true }
    allow(File).to receive(:read) { { installed: { client_id: client_id } }.to_json }
    allow_any_instance_of(Signet::OAuth2::Client).to receive(:fetch_access_token!) { true }
    Google::Calendar.client_secret_path = "testpath"
  end

  describe '.api' do
    before { allow(Google::Calendar).to receive(:authorized?) { true } }
    subject { Google::Calendar.api }
    it { is_expected.to be_instance_of Google::APIClient::API }
  end

  describe '.client' do
    subject { Google::Calendar.client }
    it { is_expected.to be_instance_of Google::APIClient }
  end

  describe '.authorize' do
    subject { Google::Calendar.authorize }
    it { is_expected.to eq true }
  end

  describe '.secret_key' do
    subject { Google::Calendar.secret_key }
    it { is_expected.to be_instance_of Google::SecretKey }
  end

  describe '.service_account' do
    subject { Google::Calendar.service_account }
    it { is_expected.to be_instance_of Google::ServiceAccount }
  end

  describe '.singing_key' do
    subject { Google::Calendar.signing_key }
    it { is_expected.to be_instance_of OpenSSL::PKey::RSA }
  end

  describe 'authorized?' do
    subject { Google::Calendar.authorized? }

    context 'authorized instance is false or nil' do
      before { Google::Calendar.instance_variable_set(:@authorized, false) }
      it { is_expected.to eq false }
    end

    context 'authorized instance is true' do
      before { Google::Calendar.instance_variable_set(:@authorized, true) }
      it { is_expected.to eq true }
    end
  end

  describe 'execute' do
    let(:method)     { Google::Calendar.api.events.get.class }
    let(:parameters) { { calendarId: id, eventId: event_id } }
    let(:body)       { "" }
    let(:options)    { { api_method: method,
                         parameters: parameters,
                         body: body,
                         headers: { 'Content-Type' => 'application/json' } } }

    before do
      expect_any_instance_of(Google::APIClient).to receive(:execute!).with(options) { true }
      allow(Google::Calendar).to receive(:authorize?) { true }
    end

    subject { Google::Calendar.execute(method, parameters, body) }
    it { is_expected.to eq true }
  end
end
