require 'spec_helper'
require 'messenger'

describe Messenger do
  describe '.send_messages' do
    context 'with no messages' do
      let(:messages) { [] }
      let(:sender) { double('Sender') }
      it 'is expected to be empty ' do
        expect(
          Messenger.send_messages(messages, sender)
        ).to be_empty
      end
    end

    context 'with mock sender' do
      let(:message_1) do
        {
          user: {
            messages_type: 'phone',
            phone:         '0400400269'
          },
          contents: 'CONTENT'
        }
      end
      let(:message_2) do
        {
          user: {
            messages_type: 'email',
            email:         'a@a.a'
          },
          contents: 'CONTENT'
        }
      end

      let(:messages) { [message_1, message_2] }

      let(:sender) { double('Sender') }

      before(:example) do
        allow(sender).to receive(:send_via_sms)
        allow(sender).to receive(:send_via_email)
      end

      it 'should pass each message to the right sender' do
        expect(sender).to receive(:send_via_sms).with(message_1)
        expect(sender).to receive(:send_via_email).with(message_2)
        Messenger.send_messages(messages, sender)
      end
    end
  end
  describe '.retrieve_messages' do
    context 'with real weather' do
      it 'should retrieve messages' do
        expect(Messenger.retrieve_messages).not_to be_empty

      end
    end
  end
end
