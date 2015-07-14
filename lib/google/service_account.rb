module Google
  class ServiceAccount
    CLIENT_ID_SUFFIX             = ".apps.googleusercontent.com"
    CLIENT_EMAIL_DOMAIN          = "developer.gserviceaccount.com"
    ACCOUNTS_GOOGLE_COM_BASE_URI = "https://accounts.google.com"
    WWW_GOOGLEAPIS_COM_BASE_URI  = "https://www.googleapis.com"
  
    attr_reader :id
    attr_reader :auth_uri, :token_uri
    attr_reader :client_id, :client_email
    attr_reader :auth_provider_x509_cert_url, :client_x509_cert_url
    attr_reader :scope

    def initialize(client_id)
      @id = client_id.include?(CLIENT_ID_SUFFIX) ? scan_id(client_id) : client_id
      @auth_uri                    = ACCOUNTS_GOOGLE_COM_BASE_URI + "/o/oauth2/auth"
      @token_uri                   = ACCOUNTS_GOOGLE_COM_BASE_URI + "/o/oauth2/token"
      @client_id                   = @id + CLIENT_ID_SUFFIX
      @client_email                = @id + "@" + CLIENT_EMAIL_DOMAIN
      @auth_provider_x509_cert_url = WWW_GOOGLEAPIS_COM_BASE_URI  + "/oauth2/v1/certs"
      @client_x509_cert_url        = WWW_GOOGLEAPIS_COM_BASE_URI  + "/robot/v1/metadata/x509" + @client_email
      @scope                       = WWW_GOOGLEAPIS_COM_BASE_URI  + "/auth/calendar"
    end

    private

    def scan_id(client_id)
      client_id.scan(/^(.*)#{CLIENT_ID_SUFFIX}$/).first.first
    end
  end
end
