require 'spec_helper'
require 'date'

describe Messenger::Joiner do
  context 'with stubbed models' do
    describe '.messages' do
      subject { Messenger::Joiner.messages(models, rules, start_date) }

      context 'with no rules' do
        let(:rules) { [] }
        let(:start_date) { Date.today }
        it { is_expected.to be_empty }
      end

      context 'with no weather' do
        before(:example) do
          allow(mildura).to receive(:run) { [] }
          allow(aireys).to receive(:run) { [] }
          allow(woop_woop).to receive(:run) { [] }
        end

        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today }
        it { is_expected.to be_empty }
      end

      context 'with two spikes and a heatwave for one day' do
        let(:message1) { double '<Message for Alice>' }
        let(:message2) { double '<Message for Dave>' }
        let(:message3) { double '<Message for Carrol>' }
        let(:message4) { double '<Message for Carrol>' }
        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today + 3 }

        before(:example) do
          date_range = start_date...(start_date + 3)
          allow(mildura).to receive(:run).with(date_range) { [] }
          allow(aireys).to receive(:run).with(date_range) { [] }
          allow(woop_woop).to receive(:run)
            .with(date_range) do
            woop_woop_weather.values_at :spike, :hot1, :hot2
          end

          date_range = start_date...(start_date + 1)
          allow(mildura).to receive(:run)
            .with(date_range) { [mildura_weather[:spike]] }
          allow(aireys).to receive(:run)
            .with(date_range) { [aireys_weather[:hot2]] }
          allow(woop_woop).to receive(:run)
            .with(date_range) { [woop_woop_weather[:spike]] }

          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: woop_woop_weather[:spike],
                  user: carrol, content: Messenger::Joiner::CONTENT)
          allow(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: alice, content: Messenger::Joiner::CONTENT)
          allow(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: dave, content: Messenger::Joiner::CONTENT)
          allow(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: woop_woop_weather[:spike],
                  user: carrol, content: Messenger::Joiner::CONTENT)
        end

        it 'should send a message for the heatwaves' do
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: woop_woop_weather[:spike],
                  user: carrol, content: Messenger::Joiner::CONTENT)
            .once { message4 }
          is_expected.to include message4
        end

        it 'should send a message for the heat spikes' do
          expect(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: alice, content: Messenger::Joiner::CONTENT)
            .once { message1 }
          expect(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: dave, content: Messenger::Joiner::CONTENT)
            .once { message2 }
          expect(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: woop_woop_weather[:spike],
                  user: carrol, content: Messenger::Joiner::CONTENT)
            .once { message3 }
          is_expected.to include message1, message2, message3
        end
      end

      context 'with two heatwaves at different locations for one day' do
        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today + 1 }
        let(:message1) { double '<Message for Alice>' }
        let(:message2) { double '<Message for Dave>' }
        let(:message3) { double '<Message for Bob>' }

        before(:example) do
          date_range = start_date...(start_date + 3)
          allow(mildura).to receive(:run)
            .with(date_range) do
            mildura_weather.values_at :hot1, :hot2, :spike
          end
          allow(aireys).to receive(:run)
            .with(date_range) do
            aireys_weather.values_at :hot1, :spike, :hot2
          end
          allow(woop_woop).to receive(:run)
            .with(date_range) { [:a, :b] }

          date_range = start_date...(start_date + 1)
          allow(mildura).to receive(:run)
            .with(date_range) { [mildura_weather[:hot1]] }
          allow(aireys).to receive(:run)
            .with(date_range) { [aireys_weather[:hot1]] }
          allow(woop_woop).to receive(:run)
            .with(date_range) { [:a] }

          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: alice, content: Messenger::Joiner::CONTENT)
          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: dave, content: Messenger::Joiner::CONTENT)
          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: aireys_weather[:hot1],
                  user: bob, content: Messenger::Joiner::CONTENT)
        end

        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today + 3 }

        it 'should send messages for the first heatwave' do
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: alice, content: Messenger::Joiner::CONTENT)
            .once { message1 }
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: dave, content: Messenger::Joiner::CONTENT)
            .once { message2 }
          is_expected.to include message1, message2
        end

        it 'should send messages for the second heatwave' do
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: aireys_weather[:hot1],
                  user: bob, content: Messenger::Joiner::CONTENT)
            .once { message3 }
          is_expected.to include message3
        end
      end
    end

    describe '.triggerings' do
      subject { Messenger::Joiner.triggerings(models, rule, start_date) }

      context 'with the wave rule' do
        let(:rule) { wave_rule }

        context 'with no waves' do
          let(:start_date) { Date.today }

          before(:example) do
            date_range = start_date...(start_date + 3)
            allow(mildura).to receive(:run)
              .with(date_range) do
              mildura_weather.values_at :cold, :hot1, :hot2
            end
            allow(aireys).to receive(:run)
              .with(date_range) do
              aireys_weather.values_at :cold, :hot1, :spike
            end
            allow(woop_woop).to receive(:run).with(date_range) { [] }
          end

          it { is_expected.to be_empty }
        end

        context 'with one wave' do
          let(:start_date) { Date.today + 4 }
          before(:example) do
            date_range = start_date...(start_date + 3)
            allow(mildura).to receive(:run)
              .with(date_range) { [] }
            allow(aireys).to receive(:run)
              .with(date_range) { %w(1 2) }
            allow(woop_woop).to receive(:run)
              .with(date_range) do
              woop_woop_weather.values_at :spike, :hot1, :hot2
            end
          end

          it 'is expected to have just that wave' do
            is_expected.to eq [woop_woop_weather[:spike]]
          end
        end

        context 'with two waves' do
          let(:start_date) { Date.today + 1 }
          before(:example) do
            date_range = start_date...(start_date + 3)
            allow(mildura).to receive(:run)
              .with(date_range) do
              mildura_weather.values_at :hot1, :hot2, :spike
            end
            allow(aireys).to receive(:run)
              .with(date_range) do
              aireys_weather.values_at :hot1, :spike, :hot2
            end
            allow(woop_woop).to receive(:run)
              .with(date_range) { [] }
          end

          it 'is expected to have all those spikes' do
            is_expected.to \
              match_array [mildura_weather[:hot1], aireys_weather[:hot1]]
          end
        end
      end

      context 'with the spike rule' do
        let(:rule) { spike_rule }

        context 'with no spike' do
          let(:start_date) { Date.today }

          before(:example) do
            date_range = start_date...(start_date + 1)
            allow(mildura).to receive(:run)
              .with(date_range) { [mildura_weather[:cold]] }
            allow(aireys).to receive(:run)
              .with(date_range) { [aireys_weather[:cold]] }
            allow(woop_woop).to receive(:run)
              .with(date_range) { [] }
          end

          it { is_expected.to be_empty }
        end

        context 'with one spike' do
          let(:start_date) { Date.today + 2 }
          before(:example) do
            date_range = start_date...(start_date + 1)
            allow(mildura).to receive(:run)
              .with(date_range) { [mildura_weather[:hot2]] }
            allow(aireys).to receive(:run)
              .with(date_range) { [aireys_weather[:spike]] }
            allow(woop_woop).to receive(:run)
              .with(date_range) { [] }
          end

          it 'is expected to have just that spike' do
            is_expected.to eq [aireys_weather[:spike]]
          end
        end

        context 'with many spikes' do
          let(:start_date) { Date.today + 3 }
          before(:example) do
            date_range = start_date...(start_date + 1)
            allow(mildura).to receive(:run)
              .with(date_range) { [mildura_weather[:spike]] }
            allow(aireys).to receive(:run)
              .with(date_range) { [aireys_weather[:hot2]] }
            allow(woop_woop).to receive(:run)
              .with(date_range) { [woop_woop_weather[:spike]] }
          end

          it 'is expected to have all those spikes' do
            is_expected.to \
              match_array [woop_woop_weather[:spike], mildura_weather[:spike]]
          end
        end
      end
    end

    describe '.recipients' do
      subject { Messenger::Joiner.recipients(rule, location) }

      let(:rule) { double '<Rule 10*C above average for 3 days>' }
      before(:example) { allow(rule).to receive(:message) { 'a test message' } }

      context 'when no users are in the location' do
        let(:location) { mildura } # Arbitrary
        before(:example) { allow(location).to receive(:users) { [] } }
        it { is_expected.to be_empty }
      end

      context 'when one user is in the location' do
        let(:location) { woop_woop } # Arbitrary
        before(:example) { allow(location).to receive(:users) { [carrol] } }
        it 'is expected to have just that user as a recipient' do
          is_expected.to eq [carrol]
        end
      end

      context 'when many users are in the location' do
        let(:location) { aireys } # Arbitrary
        before(:example) do
          allow(location).to receive(:users) { [alice, bob, carrol] }
        end
        it 'is expected to have each user in the location as a recipient' do
          is_expected.to eq [alice, bob, carrol]
        end
      end
    end

    begin # Stubs
      let(:models) do
        { weather: double('Weather'),
          user: double('User'),
          message: double('Message'),
          location: double('Location') }
      end

      let(:alice) { double '<User Alice>' }
      let(:bob) { double '<User Bob>' }
      let(:carrol) { double '<User Carrol>' }
      let(:dave) { double '<User Dave>' }

      let(:mildura) { double '<Location MILDURA RACECOURSE>' }
      let(:aireys) { double '<Location AIREYS INLET>' }
      let(:woop_woop) { double '<Location WOOP WOOP>' }

      let(:mildura_weather) do
        { cold: double('<Weather 20*C at MILDURA RACECOURSE day 0>'),
          hot1: double('<Weather 30*C at MILDURA RACECOURSE day 1>'),
          hot2: double('<Weather 30*C at MILDURA RACECOURSE day 2>'),
          spike: double('<Weather 40*C at MILDURA RACECOURSE day 3>') }
      end

      let(:aireys_weather) do
        { cold: double('<Weather 10*C at AIREYS INLET day 0>'),
          hot1: double('<Weather 20*C at AIREYS INLET day 1>'),
          spike: double('<Weather 30*C at AIREYS INLET day 2>'),
          hot2: double('<Weather 20*C at AIREYS INLET day 3>') }
      end

      let(:woop_woop_weather) do
        { spike: double('<Weather 20*C at WOOP WOOP day 3>'),
          hot1: double('<Weather 10*C at WOOP WOOP day 4>'),
          hot2: double('<Weather 10*C at WOOP WOOP day 5>'),
          cold: double('<Weather 0*C at WOOP WOOP day 6>') }
      end

      let(:spike_rule) { double '<Rule +15*C for 1 day>' }
      let(:wave_rule) { double '<Rule +10*C for 3 days>' }

      before(:example) do
        # Mildura Racecourse
        mildura_weather.values.each do |w|
          allow(w).to receive(:location) { mildura }
        end
        allow(mildura).to receive(:users) { [alice, dave] }
        allow(alice).to receive(:location) { mildura }
        allow(dave).to receive(:location) { mildura }

        # Aireys Inlet
        aireys_weather.values.each do |w|
          allow(w).to receive(:location) { aireys }
        end
        allow(aireys).to receive(:users) { [bob] }
        allow(bob).to receive(:location) { aireys }

        # Woop Woop
        woop_woop_weather.values.each do |w|
          allow(w).to receive(:location) { woop_woop }
        end
        allow(carrol).to receive(:location) { woop_woop }
        allow(woop_woop).to receive(:users) { [carrol] }

        # Rules
        allow(wave_rule).to \
          receive(:satisfied_by) { |w| wave_satisfied_by(w) }
        allow(spike_rule).to \
          receive(:satisfied_by) { |w| spike_satisfied_by(w) }
        allow(wave_rule).to receive(:duration) { 3 }
        allow(spike_rule).to receive(:duration) { 1 }

        allow(models[:location]).to receive(:all) do
          [mildura, aireys, woop_woop]
        end
      end

      def spike_satisfied_by(weather)
        case weather
        when mildura_weather[:spike],
          aireys_weather[:spike],
          woop_woop_weather[:spike]
          true
        else
          false
        end
      end

      def wave_satisfied_by(weather)
        case weather
        when mildura_weather[:cold],
          aireys_weather[:cold],
          woop_woop_weather[:cold]
          false
        else
          true
        end
      end
    end
  end

  context 'with real models' do
    subject { Messenger::Joiner.triggerings(models, rule, start_date) }
    let(:models) { { weather: Weather, user: User, message: nil } }

    describe '.triggerings' do
      let(:rule) { @rule || fail('no rule') }

      context 'with the spike rule' do
        before(:context) do
          @rule = Rule.find_or_create_by(name: 'Heatwave detection',
                                         annotation: '',
                                         duration: 1,
                                         delta: 15)
          make_weather # Set up the spikes per day as required.
        end

        context 'with no spike' do
          let(:start_date) { Date.today }
          it { is_expected.to be_empty }
        end

        context 'with one spike' do
          let(:start_date) { Date.today + 1 }
          it { is_expected.to have_size 1 }
        end

        context 'with two spikes' do
          let(:start_date) { Date.today + 2 }
          it { is_expected.to have_size 2 }
        end
      end
    end

    def make_weather
      (0..2).each { |i| make_weather_for(@mildura, i, i) }
      (1..2).each { |i| make_weather_for(@aireys, i, 1) }
    end

    def make_weather_for(location, cycle, deltas)
      start = Date.today + cycle * @rule.duration
      finish = start + @rule.duration
      (start...finish).each do |d|
        temp = location.mean_for(d) + @rule.delta * deltas + 1
        Weather.update_or_create_by({ location: location, date: d },
                                    { high_temp: temp })
      end
    end

    before(:context) do
      Messenger::Database.initialise
      @mildura = Location.find_or_create_by(
        name: 'MILDURA RACECOURSE',
        jan_mean: 25.0,
        feb_mean: 22.1,
        mar_mean: 18.2,
        apr_mean: 14.3,
        may_mean: 12.4,
        jun_mean: 10.5,
        jul_mean: 8.6,
        aug_mean: 12.7,
        sep_mean: 14.8,
        oct_mean: 18.9,
        nov_mean: 20.0,
        dec_mean: 24.1)
      @aireys = Location.find_or_create_by(
        name: 'AIREYS INLET',
        jan_mean: 22.5,
        feb_mean: 20.4,
        mar_mean: 17.3,
        apr_mean: 12.2,
        may_mean: 9.1,
        jun_mean: 8.0,
        jul_mean: 7.9,
        aug_mean: 10.8,
        sep_mean: 11.7,
        oct_mean: 16.6,
        nov_mean: 19.5,
        dec_mean: 21.4)
    end
  end
end
