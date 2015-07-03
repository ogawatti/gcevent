require 'google/service_account'
require 'google/calendar/event'
require 'google/api_client'
require 'hashie'

module Google
  class SecretKey < Hashie::Mash; end

  module Calendar
    class << self
      attr_accessor :id, :client_id
    end

    extend self

    def api
      authorize unless authorized?
      client.discovered_api('calendar', 'v3')
    end

    def client
      @client ||= Google::APIClient.new(:application_name => '')
    end

    def authorize
      raise Errno::ENOENT.new(secret_key.path) unless File.exist?(secret_key.path)
      client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: service_account.token_uri,
        audience:             service_account.token_uri,
        scope:                service_account.scope,
        issuer:               service_account.client_email,
        signing_key:          signing_key
      )
      client.authorization.fetch_access_token!
      @authorized = true
    end

    def secret_key
      @secret_key ||= Google::SecretKey.new({ path: nil, password: nil })
    end

    def service_account
      Google::ServiceAccount.new(client_id)
    end

    def signing_key
      Google::APIClient::KeyUtils.load_from_pkcs12(secret_key.path, secret_key.password)
    end

    def authorized?
      @authorized
    end

    # MEMO : body_objectでなくbodyを使う
    #  * 公式のReference的にはbody_object
    #   * body_objectを空文字指定でEvent#getすると400 Bad Request
    #   * 必要ないときはパラメータに含めない方がよさそう
    #  * bodyパラメータなら空文字指定でもOK
    def execute(api_method, parameters={}, body="")
      options = { api_method:  api_method,
                  parameters:  parameters,
                  body:        body,
                  headers: { 'Content-Type' => 'application/json' } }
      client.execute!(options)
    end
  end
end
