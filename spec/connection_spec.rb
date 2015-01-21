require 'spec_helper'
require 'savon/mock/spec_helper'


describe ActiveZuora::Connection do

  include Savon::SpecHelper

  context "custom header" do

    # set Savon in and out of mock mode
    before(:all) { savon.mock!   }
    after(:all)  { savon.unmock! }

    before do
      @connection = ActiveZuora::Connection.new
      @stub_was_called = false
    end

    it "passes the regular header if not set" do
      allow(Savon::Client).to receive(:new) do |config, http, soap|
        @stub_was_called = true
        expect(soap.header).to eq( { "SessionHeader" => {"session" => nil} } )

        double('response').as_null_object
      end

      @connection.request(:amend) {}

      expect(@stub_was_called).to be_truthy
    end

    it "merges in a custom header if set" do
      @connection.custom_header = {'CallOptions' => {'useSingleTransaction' => true}}
      allow(Savon::Request).to receive(:new) do |config, http, soap|
        @stub_was_called = true
        expect(soap.header).to eq( { "SessionHeader" => {"session" => nil}, 'CallOptions' => {'useSingleTransaction' => true} } )

        double('response').as_null_object
      end

      @connection.request(:amend) {}

      expect(@stub_was_called).to be_truthy
    end
  end
end
