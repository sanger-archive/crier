require './spec/spec_helper'
require './crier'

describe Crier do

  context 'the message index' do
    it "should display the messages" do
      get '/messages'
      expect(last_response).to be_ok
      expect(last_response.body).to include "What's going on..."
      expect(last_response.body).to include "Test a"
      expect(last_response.body).to include "This is an example"
    end

    it "should return json if requested" do
      get '/messages', {}, {'HTTP_ACCEPT' => 'application/json'}
      expect(last_response).to be_ok
      expect(JSON.load(last_response.body)).to eq(
        {"messages"=>[
          {
            "body"=>"This is an example",
            "date"=>"2015-01-01 00:00:00 +0000",
            "types"=>["warning","status"],
            "name"=>"test_a"
          },
          {
            "body"=>"This is another example",
            "date"=>"2015-01-02 00:00:00 +0000",
            "types"=>["success","uat"],
            "name"=>"test_b"
          }
        ]}
      )
    end

    context 'should allow message creation' do
    end

  end

  context 'an individual message' do

    let(:example_name)         { 'example' }
    let(:example_display_name) { 'Example' }
    let(:example_body)         { 'This is a message' }
    let(:example_types)        { ['type-a','type-b'] }

    let(:time_created)  { Time.new('2015-01-01 16:30:00 +0100') }
    let(:at_fixed_time) { allow(Time).to receive(:now).and_return(time_created) }

    let(:message_to_delete) { double('message_to_delete').tap {|sfd| expect(sfd).to receive(:delete)                                  }  }
    let(:message_to_update) { double('message_to_update').tap {|sfd| expect(sfd).to receive(:update).with(example_body,example_types) }  }

    it "should be deletable" do
      expect(Message).to receive(:find).with(example_name).and_return(message_to_delete)
      delete "/messages/#{example_name}"
      expect(last_response).to be_ok
      expect(last_response.body).to include("Message #{example_name} was deleted.")
    end

    it "should be deletable via the API" do
      expect(Message).to receive(:find).with(example_name).and_return(message_to_delete)
      delete "/messages/#{example_name}", {}, {'HTTP_ACCEPT' => 'application/json'}
      expect(last_response).to be_ok
      expect(JSON.load(last_response.body)).to eq({
        "message"=>"Message #{example_name} was deleted.",
        "status"=>"success"
      })
    end

    it "should be updateable" do
    end

    it "should be gettable" do
    end

  end

end
