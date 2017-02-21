module Google
  class ServiceAccount
    SCOPE = 'https://www.googleapis.com/auth/calendar'
  
    attr_reader :auth_uri, :token_uri
    attr_reader :client_id, :client_email
    attr_reader :auth_provider_x509_cert_url, :client_x509_cert_url
    attr_reader :project_id
    attr_reader :scope

    def initialize(secret_path, email)
      JSON.parse(File.read(secret_path)).each do |key, secret|
        secret.each do |k, v|
          instance_varialbe_name = "@#{k}".to_sym
          instance_variable_set(instance_varialbe_name, v)
        end
      end
      @client_email ||= email
      @scope = SCOPE
    end
  end
end
