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
      expect(subject.options.client_options.authorize_url).to eq('/yconnect/v1/authorization')
    end

    it 'shoud have client' do
      p subject.client
    end
  end
end
