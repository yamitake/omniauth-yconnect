require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies

    # An omniauth 1.0 strategy for yahoo authentication
    class Yconnect < OmniAuth::Strategies::OAuth2

      option :name, 'yconnect'

      option :client_options, {
        :access_token_url   => '/yconnect/v1/token',
        :authorize_url      => '/yconnect/v1/authorization',
        :token_url          => '/yconnect/v1/token',
        :user_info_url      => 'https://userinfo.yahooapis.jp/yconnect/v1/attribute',
        :site               => 'https://auth.login.yahoo.co.jp' ,
      }

      uid {
        #access_token.params['xoauth_yahoo_guid']
        raw_info['user_id']

      }

      info do
        {
          :user_id                => user_info["user_id"] ,
          :name                   => user_info['name'] ,
          :given_name             => user_info['given_name'] ,
          :given_name_ja_kana_jP  => user_info['given_name#ja-Kana-JP'] ,
          :given_name_ja_hani_jP  => user_info['given_name#ja-Hani-JP'] ,
          :family_name            => user_info['family_name'] ,
          :family_name_ja_kana_jP => user_info['family_name#ja-Kana-JP'] ,
          :family_name_ja_hani_jP => user_info['family_name#ja-Hani-JP'] ,
          :locale                 => user_info['locale'] ,
          :email                  => user_info['email'] ,
          :email_verified         => user_info['email_verified'] ,
          :address                =>  {
                                    "country"     => user_info["address"] ? user_info["address"]["country"] : nil ,
                                    "postal_code" => user_info["address"] ? user_info["address"]["postal_code"] : nil ,
                                    "region"      => user_info["address"] ? user_info["address"]["region"] : nil ,
                                    "locality"    => user_info["address"] ? user_info["address"]["locality"] : nil
                                    } ,
          :birthday               => user_info['birthday'] ,
          :gender                 => user_info['gender']
        }
      end

      extra do
        hash = {}
        hash[:raw_info] = raw_info unless skip_info?
        hash
      end

      def build_access_token
        options.token_params = {} if options.token_params.nil?
        options.auth_token_params = {} if options.auth_token_params.nil?
        params = {}
        params[:body] = {:redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true))
        params[:body].merge!({'grant_type' => 'authorization_code', 'code' => request.params['code']})
        params[:headers] = {'Expect'=> '' ,
                            'Authorization' => 'Basic ' + Base64::strict_encode64("#{options.client_id}:#{options.client_secret}").strip}
        params.delete "client_id"
        params.delete "client_secret"
        params.merge(token_params.to_hash(:symbolize_keys => true))
        get_token( params , deep_symbolize(options.auth_token_params))
      end

      def get_token(params, access_token_opts={})
        opts = {:raise_errors => options[:raise_errors], :parse => params.delete(:parse)}
        response = client.request(:post , client.token_url, params.merge(opts))
        raise Error.new(response) if client.options[:raise_errors] && !(response.parsed.is_a?(Hash) && response.parsed['access_token'])
        ::OAuth2::AccessToken.from_hash(client , response.parsed.merge(access_token_opts))
      end

      # Refreshes the current Access Token
      #
      # @return [AccessToken] a new AccessToken
      # @note options should be carried over to the new AccessToken
      def refresh!(params={})
        raise "A refresh_token is not available" unless refresh_token
        params.merge!(
                      :grant_type     => 'refresh_token',
                      :refresh_token  => refresh_token)
        params[:headers] = {'Expect'=> '' ,
                            'Authorization' => 'Basic ' + Base64::strict_encode64("#{options.client_id}:#{options.client_secret}").strip}
        new_token = get_token(params)
        new_token.options = client.options
        new_token
      end

      # Return info gathered from the v1/user/:id/profile API call

      def raw_info
        return @raw_info if @raw_info
        # This is a public API and does not need signing or authentication
        url = "https://userinfo.yahooapis.jp/yconnect/v1/attribute"
        opts = {:headers => {'Authorization' => access_token.params["token_type"].camelize + ' ' + access_token.token}}
        opts[:params] = {:schema => 'openid'}
        @raw_info ||= MultiJson.decode(client.request(:get , url , opts).body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end

      # Provide the "Profile" portion of the raw_info

      def user_info
        @user_info ||= raw_info.nil? ? {} : raw_info
      end
    end
  end
end