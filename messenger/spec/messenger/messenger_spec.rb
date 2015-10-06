require 'spec_helper'
require 'messenger'
require 'date'

describe Messenger do
  describe '.send_messages' do
    context 'with no messages' do
      let(:messages) { [] }
      let(:sender) { double('Sender') }
      it 'is expected to do nothing ' do
        expect(sender).not_to receive(:send_via_sms)
        expect(sender).not_to receive(:send_via_email)
        expect(Messenger.send_messages(messages, sender)).to be_empty
      end
    end

    let(:phone_user) { double('phone_user') }
    let(:email_user) { double('email_user') }
    let(:bad_user) { double('bad_user') }

    let(:message_1) { double('1st_message') }
    let(:message_2) { double('2nd_message') }
    let(:message_3) { double('3rd_message') }
    let(:message_4) { double('4th_message') }

    let(:messages) { [message_2, message_1] }

    context 'with mock messages' do
      context 'with real sender but message too long' do
        before do
          allow(message_3).to receive(:user) { phone_user }
          allow(message_3).to receive(:contents) { 'long message' * 160 }
          allow(message_3).to receive(:save) { true }
          allow(phone_user).to receive(:phone) { '0400400269' }
          allow(phone_user).to receive(:message_type) { 'phone' }
        end

        it 'should cause an error' do
          result = Messenger.send_messages([message_3])
          expect(result.length).to be 1
          expect(result.at(0)[:message]).to be message_3
          expect(result.at(0)[:error].class).to \
            eq Messenger::SmsWrapper::SmsTooLongError
        end
      end

      context 'with mock sender' do
        let(:sender) { double('Sender') }
        before do
          allow(message_1).to receive(:user) { phone_user }
          allow(message_1).to receive(:contents) { 'CONTENT' }
          allow(message_1).to receive(:save) { true }
          allow(message_1).to receive(:send_time=) { true }
          allow(phone_user).to receive(:phone) { '0400400269' }
          allow(phone_user).to receive(:message_type) { 'phone' }

          allow(message_2).to receive(:user) { email_user }
          allow(message_2).to receive(:contents) { 'CONTENT' }
          allow(message_2).to receive(:save) { true }
          allow(message_2).to receive(:send_time=) { true }
          allow(email_user).to receive(:email) { 'a@a.a' }
          allow(email_user).to receive(:message_type) { 'email' }

          allow(message_4).to receive(:user) { bad_user }
          allow(message_4).to receive(:save) { true }
          allow(message_4).to receive(:send_time=) { true }
          allow(bad_user).to receive(:message_type) { 'carrier_pigeon' }
        end

        it 'should pass each message to the right sender' do
          expect(sender).to receive(:send_via_sms).with(message_1).once
          expect(sender).to receive(:send_via_email).with(message_2).once
          expect(Messenger.send_messages(messages, sender)).to be_empty
        end

        it 'should fail if message_type is not email or phone' do
          result = Messenger.send_messages([message_4])
          expect(result.length).to be 1
          expect(result.at(0)[:message]).to be message_4
          expect(result.at(0)[:error].class).to \
            eq Messenger::MessageTypeError
        end
      end
    end

    context 'with real database objects', speed: 'slow' do
      before(:example) do
        Messenger::Database.initialise
        Rule.destroy_all
        @spike_rule = Rule.find_or_create_by(
          name: 'Testing: Heat spike detection',
          key_advice: 'Hello, this is a test message from HeatWave',
          full_advice: 'full advice text',
          activated: true,
          duration: 1,
          delta: 15)
        @mildura = Location.find_or_create_by(
          name: 'MILDURA RACECOURSE',
          jan_mean: 25.0, feb_mean: 22.1, mar_mean: 18.2, apr_mean: 14.3,
          may_mean: 12.4, jun_mean: 10.5, jul_mean: 8.6, aug_mean: 12.7,
          sep_mean: 14.8, oct_mean: 18.9, nov_mean: 20.0, dec_mean: 24.1)
        @weather = Weather.update_or_create_by(
          { location: @mildura, date: Date.today }, high_temp: 100)
        User.destroy_all
        @alice = User.create(
          username: 'asanchez',
          password: '123',
          f_name: 'Alice',
          l_name: 'Sanchez',
          gender: 'F',
          age: 1,
          phone: '0400400269',
          message_type: 'phone',
          location: @mildura)
        @bob = User.create(
          username: 'bobr',
          password: 'abc',
          f_name: 'Bob',
          l_name: 'Roberts',
          gender: 'M',
          age: 2,
          message_type: 'email',
          email: 'a@a.a',
          location: @mildura)
        Message.destroy_all
        message_content = 'Hello, this is a test message from HeatWave'
        @message_model_1 = Message.create(
          user: @alice,
          contents: message_content,
          rule: @spike_rule,
          weather: @weather
        )
        @message_model_2 = Message.create(
          user: @bob,
          contents: message_content,
          rule: @spike_rule,
          weather: @weather
        )
      end
      let(:messages) { [@message_model_1, @message_model_2] }

      let(:sender) { double('Sender') }

      it 'should pass each message to the right sender' do
        expect(sender).to receive(:send_via_sms).with(@message_model_1).once
        expect(sender).to receive(:send_via_email).with(@message_model_2).once
        expect(Messenger.send_messages(messages, sender)).to be_empty
        expect(Message.find(@message_model_1.id).send_time).not_to be nil
        expect(Message.find(@message_model_2.id).send_time).not_to be nil
      end
    end
  end
  describe '.retrieve_messages', speed: 'slow' do
    context 'with real weather' do
      let(:joiner) { double('Joiner') }
      it 'should retrieve messages' do
        expect(joiner).to receive(:messages).with(
          { location: Location,
            message:  Message,
            user:     User },
          Rule.all,
          Date.today
        )

        Messenger.retrieve_messages joiner
      end
    end
  end
end
