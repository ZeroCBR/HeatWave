require 'spec_helper'

describe Messenger do

  describe '.send_messages' do
    subject { Messenger.send_messages(messages, sender) }

    context 'with no messages' do
      let(:messages) { [] }
      let(:sender ) { double('Sender') }
      it { is_expected.to be_empty }
    end

    context 'with mock sender' do
      let(:message_1) { [ {
          user:     {
            messages_type: 'phone',
            phone:         '0400400269'
            },
          contents: 'CONTENT' }] }
      let(:message_2) { [ {
          user:     {
            messages_type: 'email',
            email:         'a@a.a'
            },
          contents: 'CONTENT' }] }

      let(:messages) { [message_1, message_2] }
      
      let(:sender) { double('Sender') }

      before(:example) do
        allow(sender).to receive(:send_via_sms)
        allow(sender).to receive(:send_via_email)
      end

      it 'should pass the message to the right sender' do
        expect(sender).to receive(:send_via_sms).with(message_1)
        expect(sender).to receive(:send_via_email).with(message_2)

      end
    end
  end
end
