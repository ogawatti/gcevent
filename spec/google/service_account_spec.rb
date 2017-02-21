require 'spec_helper'

describe Google::ServiceAccount do
  before { allow(File).to receive(:read) { secret.to_json } }
  let(:client_secret_path) { "./testpath" }
  let(:client_email)       { "test@example.com" }
  let(:secret) {
    {
      installed: {
        client_id:                   "100000000000000000000",
        project_id:                  "test-project-000001",
        auth_uri:                    "https://accounts.google.com/o/oauth2/auth",
        token_uri:                   "https://accounts.google.com/o/oauth2/token",
        auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs"
      }
    }
  }

  describe '#initialize' do
    it 'should be instance of Google::ServiceAccount' do
      service_account = Google::ServiceAccount.new(client_secret_path, client_email)
      secret[:installed].each do |k, v|
        expect(service_account.send(k)).to eq v
      end
      expect(service_account.client_email).to eq client_email
    end
  end
end
