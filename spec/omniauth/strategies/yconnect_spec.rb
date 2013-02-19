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
      expect(subject.options.client_options.authorize_path).to eq('https://auth.login.yahoo.co.jp/yconnect/v1/authorization')
    end
  end
end
