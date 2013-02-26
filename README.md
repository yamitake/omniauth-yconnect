# Omniauth::Yconnect
YConnect OAuth2 Strategy for OmniAuth 1.0.

Supports the OAuth 2.0 server-side and client-side flows. Read the YConnect docs for more details:

[Yahoo!デベロッパーネットワークトップ>YConnect](http://developer.yahoo.co.jp/yconnect/)

TODO: refactoring

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-yconnect'


## Usage
OmniAuth::Strategies::Facebook is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: [https://github.com/intridea/omniauth](https://github.com/intridea/omniauth)

※例を示します。scope等はドキュメントを確認してください。

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :facebook, ENV['YCONNECT_APPLICATION_ID'], ENV['FACEBOOK_SECRET']
      :scope => %W(
            openid
            profile
            email
            address
          ).join(' ')
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
