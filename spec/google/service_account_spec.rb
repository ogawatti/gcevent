require 'spec_helper'

describe Google::ServiceAccount do
  let(:client_id_suffix)             { ".apps.googleusercontent.com" }
  let(:client_email_domain)          { "developer.gserviceaccount.com" } 
  let(:accounts_google_com_base_uri) { "https://accounts.google.com" }
  let(:www_googleapis_com_base_uri)  { "https://www.googleapis.com" }

  let(:id)                           { "1000000000000-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" }
  let(:client_id)                    { id + ".apps.googleusercontent.com" }
  let(:auth_uri)                     { accounts_google_com_base_uri + "/o/oauth2/auth" }
  let(:token_uri)                    { accounts_google_com_base_uri + "/o/oauth2/token" }
  let(:client_email)                 { id + "@" + client_email_domain }
  let(:auth_provider_x509_cert_url)  { www_googleapis_com_base_uri + "/oauth2/v1/certs" }
  let(:client_x509_cert_url)         { www_googleapis_com_base_uri + "/robot/v1/metadata/x509" + client_email }
  let(:scope)                        { www_googleapis_com_base_uri + "/auth/calendar" }


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

  describe '#initialize' do
    it 'should be instance of Google::ServiceAccount' do
     service_account = Google::ServiceAccount.new(client_id)
     expect(service_account.id).to eq id
     expect(service_account.auth_uri).to eq auth_uri
     expect(service_account.token_uri).to eq token_uri
     expect(service_account.client_id).to eq client_id
     expect(service_account.client_email).to eq client_email
     expect(service_account.auth_provider_x509_cert_url).to eq auth_provider_x509_cert_url
     expect(service_account.client_x509_cert_url).to eq client_x509_cert_url
     expect(service_account.scope).to eq scope
    end
  end
end
