require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Geni < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :site => 'https://www.geni.com',
        :authorize_url => '/platform/oauth/authorize'
        :token_url => '/platform/oauth/request_token'
      }

      option :authorize_params, {
        
      }

      option :name, 'geni'

      option :access_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }
      
      option :authorize_options, [:scope, :display]

      def request_phase
        super
      end

      def build_access_token
        token_params = {
          :code => request.params['code'],
          :redirect_uri => callback_url,
          :client_id => client.id,
          :client_secret => client.secret
        }
        client.get_token(token_params)
      end
      
      uid { raw_info['id'] }
      
      info do
        {
          'name' => raw_info['name']
        }
      end
      
      def raw_info
        @raw_info ||= access_token.get('/api/profile')
      end

    end
  end
end

OmniAuth.config.add_camelization 'geni', 'Geni'
