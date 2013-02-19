require 'spec_helper'

describe OmniAuth::Strategies::Yconnect do
  subject do
    OmniAuth::Strategies::Yconnect.new({})
  end

  context 'client options' do
    it 'should have correct name' do
      expect(subject.options.name).to eq('yconnect')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_path).to eq('/yconnect/v1/authorization')
    end

    it 'should be true authrorize_url' do
      # p subject
      # p "aaaaaaaaaaaaaaaaaaaaaaaafsdfsd"
      # p subject.client
      # p "ssssssssssssssssssssssssssssssssssssssssssssssss"
      # p subject.client.auth_code
      # p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
      # p subject.authorize_params
      # p "aaaaaaaaaaaaaaaaaaaaaaabkjflksdjfkjsdfkj"
      # p subject.callback_url
      # p "bbbbbbbbbbbbbbbbbbbbbbbbbb"
      # p subject.client.auth_code.authorize_url({:redirect_uri => subject.callback_url}.merge())
    end
  end
end
