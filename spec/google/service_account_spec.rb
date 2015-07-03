require 'spec_helper'

describe Google::ServiceAccount do
  let(:client_id_suffix)             { ".apps.googleusercontent.com" }
  let(:client_email_domain)          { "developer.gserviceaccount.com" } 
  let(:accounts_google_com_base_uri) { "https://accounts.google.com" }
  let(:www_googleapis_com_base_uri)  { "https://www.googleapis.com" }
  let(:client_id) { "1000000000000-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.apps.googleusercontent.com" }

  describe '::CLIENT_ID_SUFFIX' do
    subject { Google::ServiceAccount::CLIENT_ID_SUFFIX }
    it { is_expected.to eq client_id_suffix }
  end

  describe '::CLIENT_EMAIL_DOMAIN' do
    subject { Google::ServiceAccount::CLIENT_EMAIL_DOMAIN }
    it { is_expected.to eq client_email_domain }
  end

  describe '::ACCOUNTS_GOOGLE_COM_BASE_URI' do
    subject { Google::ServiceAccount::ACCOUNTS_GOOGLE_COM_BASE_URI }
    it { is_expected.to eq accounts_google_com_base_uri }
  end

  describe '::WWW_GOOGLEAPIS_COM_BASE_URI' do
    subject { Google::ServiceAccount::WWW_GOOGLEAPIS_COM_BASE_URI }
    it { is_expected.to eq www_googleapis_com_base_uri }
  end

  # DOING
  describe '#initialize' do
  end
end
