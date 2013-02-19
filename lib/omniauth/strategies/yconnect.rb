require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies

    # An omniauth 1.0 strategy for yahoo authentication
    class Yconnect < OmniAuth::Strategies::OAuth2

      option :name, 'yconnect'

      option :client_options, {
        :access_token_path  => '/yconnect/v1/token',
        :access_token_url   => '/yconnect/v1/token',
        :authorize_path     => '/yconnect/v1/authorization',
        :authorize_url      => '/yconnect/v1/authorization',
        :request_token_path => '/yconnect/v1/token',
        :token_url          => '/yconnect/v1/token',
        :user_info_path     => 'https://userinfo.yahooapis.jp/yconnect/v1/attribute',
        :user_info_url      => 'https://userinfo.yahooapis.jp/yconnect/v1/attribute',
        :site               => 'https://auth.login.yahoo.co.jp'
      }

      uid {
        #access_token.params['xoauth_yahoo_guid']
        raw_info['id']
      }

      info do
        primary_email = nil
        if user_info['emails']
          email_info    = user_info['emails'].find{|e| e['primary']} || user_info['emails'].first
          primary_email = email_info['handle']
        end
        {
          :nickname    => user_info['nickname'],
          :name        => user_info['givenName'] || user_info['nickname'],
          :image       => user_info['image']['imageUrl'],
          :description => user_info['message'],
          :email       => primary_email,
          :urls        => {
            'Profile' => user_info['profileUrl'],
          }
        }
      end

      extra do
        hash = {}
        hash[:raw_info] = raw_info unless skip_info?
        hash
      end

      # Return info gathered from the v1/user/:id/profile API call

      def raw_info
        # This is a public API and does not need signing or authentication
        request = "https://userinfo.yahooapis.jp/yconnect/v1/attribute/#{uid}/profile?format=json"
        @raw_info ||= MultiJson.decode(access_token.get(request).body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      # Provide the "Profile" portion of the raw_info

      def user_info
        @user_info ||= raw_info.nil? ? {} : raw_info["profile"]
      end
    end
  end
end