require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Geni < OmniAuth::Strategies::OAuth2

      option :client_options, {
        :site => 'https://www.geni.com',
        :authorize_url => '/platform/oauth/authorize',
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
        prune!({
          'name'           => raw_info['name'],
          'first_name'     => raw_info['first_name'],
          'last_name'      => raw_info['last_name'],
          'email'          => raw_info['email'],
          'gender'         => raw_info['gender'],
          'mugshot_urls'   => raw_info['mugshot_urls'],
          'name'           => raw_info['name'],
          'url'            => raw_info['url'],
        })
      end
      
      extra do 
        { 'profile' =>  prune!(raw_info) }
      end
      
      def raw_info
        @raw_info ||= access_token.get('/api/profile').parsed
      end

      def authorize_params
        super.tap do |params|
          params.merge!(:display => request.params['display']) if request.params['display']
          params.merge!(:state => request.params['state']) if request.params['state']
          params[:scope] ||= 'email'
        end
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

    end
  end
end

OmniAuth.config.add_camelization 'geni', 'Geni'
