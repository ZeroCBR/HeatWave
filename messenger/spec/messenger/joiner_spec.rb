require 'spec_helper'
require 'date'
ROOT_URL = 'localhost:3000'
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
          allow(mildura).to receive(:weather_run) { [] }
          allow(aireys).to receive(:weather_run) { [] }
          allow(woop_woop).to receive(:weather_run) { [] }
        end

        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today }
        it { is_expected.to be_empty }
      end

      context 'with two spikes and a heatwave for one day' do
        let(:message1) { double '<Message for Alice>' }
        let(:message2) { double '<Message for Dave>' }
        let(:message3) { double '<Message for Carol>' }
        let(:message4) { double '<Message for Carol>' }
        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today + 3 }

        before(:example) do
          date_range = start_date...(start_date + 3)
          allow(mildura).to receive(:weather_run).with(date_range) { [] }
          allow(aireys).to receive(:weather_run).with(date_range) { [] }
          allow(woop_woop).to receive(:weather_run)
            .with(date_range) do
            woop_woop_weather.values_at :spike, :hot1, :hot2
          end

          date_range = start_date...(start_date + 1)
          allow(mildura).to receive(:weather_run)
            .with(date_range) { [mildura_weather[:spike]] }
          allow(aireys).to receive(:weather_run)
            .with(date_range) { [aireys_weather[:hot2]] }
          allow(woop_woop).to receive(:weather_run)
            .with(date_range) { [woop_woop_weather[:spike]] }

          allow(spike_rule).to receive(:key_advice) { :advice }
          allow(wave_rule).to receive(:key_advice) { :advice }
          allow(spike_rule).to receive(:id) { :id }
          allow(wave_rule).to receive(:id) { :id }

          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: woop_woop_weather[:spike],
                  user: carol, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
          allow(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: alice, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
          allow(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: dave, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
          allow(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: woop_woop_weather[:spike],
                  user: carol, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
        end

        it 'should send a message for the heatwaves' do
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: woop_woop_weather[:spike],
                  user: carol, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
            .once { message4 }
          is_expected.to include message4
        end

        it 'should send a message for the heat spikes' do
          expect(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: alice, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
            .once { message1 }
          expect(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: mildura_weather[:spike],
                  user: dave, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
            .once { message2 }
          expect(models[:message]).to receive(:new)
            .with(rule: spike_rule, weather: woop_woop_weather[:spike],
                  user: carol, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
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
          allow(mildura).to receive(:weather_run)
            .with(date_range) do
            mildura_weather.values_at :hot1, :hot2, :spike
          end
          allow(aireys).to receive(:weather_run)
            .with(date_range) do
            aireys_weather.values_at :hot1, :spike, :hot2
          end
          allow(woop_woop).to receive(:weather_run)
            .with(date_range) { [:a, :b] }

          date_range = start_date...(start_date + 1)
          allow(mildura).to receive(:weather_run)
            .with(date_range) { [mildura_weather[:hot1]] }
          allow(aireys).to receive(:weather_run)
            .with(date_range) { [aireys_weather[:hot1]] }
          allow(woop_woop).to receive(:weather_run)
            .with(date_range) { [:a] }

          allow(spike_rule).to receive(:key_advice) { :advice }
          allow(wave_rule).to receive(:key_advice) { :advice }
          allow(spike_rule).to receive(:id) { :id }
          allow(wave_rule).to receive(:id) { :id }

          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: alice, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: dave, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
          allow(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: aireys_weather[:hot1],
                  user: bob, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
        end

        let(:rules) { [spike_rule, wave_rule] }
        let(:start_date) { Date.today + 3 }

        it 'should send messages for the first heatwave' do
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: alice, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
            .once { message1 }
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: mildura_weather[:hot1],
                  user: dave, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
            .once { message2 }
          is_expected.to include message1, message2
        end

        it 'should send messages for the second heatwave' do
          expect(models[:message]).to receive(:new)
            .with(rule: wave_rule, weather: aireys_weather[:hot1],
                  user: bob, contents: "#{:advice} Read more at: "\
                   "#{ROOT_URL}/rules/#{:id}")
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
            allow(mildura).to receive(:weather_run)
              .with(date_range) do
              mildura_weather.values_at :cold, :hot1, :hot2
            end
            allow(aireys).to receive(:weather_run)
              .with(date_range) do
              aireys_weather.values_at :cold, :hot1, :spike
            end
            allow(woop_woop).to receive(:weather_run).with(date_range) { [] }
          end

          it { is_expected.to be_empty }
        end

        context 'with one wave' do
          let(:start_date) { Date.today + 4 }
          before(:example) do
            date_range = start_date...(start_date + 3)
            allow(mildura).to receive(:weather_run)
              .with(date_range) { [] }
            allow(aireys).to receive(:weather_run)
              .with(date_range) { %w(1 2) }
            allow(woop_woop).to receive(:weather_run)
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
            allow(mildura).to receive(:weather_run)
              .with(date_range) do
              mildura_weather.values_at :hot1, :hot2, :spike
            end
            allow(aireys).to receive(:weather_run)
              .with(date_range) do
              aireys_weather.values_at :hot1, :spike, :hot2
            end
            allow(woop_woop).to receive(:weather_run)
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
            allow(mildura).to receive(:weather_run)
              .with(date_range) { [mildura_weather[:cold]] }
            allow(aireys).to receive(:weather_run)
              .with(date_range) { [aireys_weather[:cold]] }
            allow(woop_woop).to receive(:weather_run)
              .with(date_range) { [] }
          end

          it { is_expected.to be_empty }
        end

        context 'with one spike' do
          let(:start_date) { Date.today + 2 }
          before(:example) do
            date_range = start_date...(start_date + 1)
            allow(mildura).to receive(:weather_run)
              .with(date_range) { [mildura_weather[:hot2]] }
            allow(aireys).to receive(:weather_run)
              .with(date_range) { [aireys_weather[:spike]] }
            allow(woop_woop).to receive(:weather_run)
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
            allow(mildura).to receive(:weather_run)
              .with(date_range) { [mildura_weather[:spike]] }
            allow(aireys).to receive(:weather_run)
              .with(date_range) { [aireys_weather[:hot2]] }
            allow(woop_woop).to receive(:weather_run)
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
        before(:example) { allow(location).to receive(:users) { [carol] } }
        it 'is expected to have just that user as a recipient' do
          is_expected.to eq [carol]
        end
      end

      context 'when many users are in the location' do
        let(:location) { aireys } # Arbitrary
        before(:example) do
          allow(location).to receive(:users) { [alice, bob, carol] }
        end
        it 'is expected to have each user in the location as a recipient' do
          is_expected.to eq [alice, bob, carol]
        end
      end
    end

    begin # Stubs
      let(:models) do
        { message: double('Message'), location: double('Location') }
      end

      let(:alice) { double '<User Alice>' }
      let(:bob) { double '<User Bob>' }
      let(:carol) { double '<User Carol>' }
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
        allow(carol).to receive(:location) { woop_woop }
        allow(woop_woop).to receive(:users) { [carol] }

        # Rules
        allow(wave_rule).to \
          receive(:satisfied_by?) { |w| wave_satisfied_by?(w) }
        allow(spike_rule).to \
          receive(:satisfied_by?) { |w| spike_satisfied_by?(w) }
        allow(wave_rule).to receive(:duration) { 3 }
        allow(spike_rule).to receive(:duration) { 1 }

        allow(models[:location]).to receive(:all) do
          [mildura, aireys, woop_woop]
        end
      end

      def spike_satisfied_by?(weather)
        case weather
        when mildura_weather[:spike],
          aireys_weather[:spike],
          woop_woop_weather[:spike]
          true
        else
          false
        end
      end

      def wave_satisfied_by?(weather)
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

  context 'with real models', speed: 'slow' do
    let(:models) { { location: Location, message: Message } }

    describe '.messages' do
      subject { Messenger::Joiner.messages(models, rules, start_date) }
      let(:start_date) { Date.today - 10 }

      context 'with no rules' do
        let(:rules) { [] }
        let(:start_date) { Date.today }
        it { is_expected.to be_empty }
      end

      context 'with no weather' do
        let(:rules) { [@spike_rule, @wave_rule] }
        it { is_expected.to be_empty }
      end

      context 'with two spikes and a heatwave for one day' do
        let(:rules) { [@spike_rule, @wave_rule] }

        before(:example) do
          temp = @mildura.mean_for(start_date) + @spike_rule.delta + 1
          Weather.update_or_create_by(
            { location: @mildura, date: start_date }, high_temp: temp)
          temp = @mildura.mean_for(start_date + 1) + @spike_rule.delta + 1
          Weather.update_or_create_by(
            { location: @mildura, date: start_date + 1 }, high_temp: temp)
          temp = @mildura.mean_for(start_date + 2) + @spike_rule.delta + 1
          Weather.update_or_create_by(
            { location: @mildura, date: start_date + 2 }, high_temp: temp)
          temp = @aireys.mean_for(start_date) + @spike_rule.delta + 1
          Weather.update_or_create_by(
            { location: @aireys, date: start_date }, high_temp: temp)
          w = Weather.find_by(location: @aireys, date: start_date + 1)
          w.destroy if w
        end

        it 'should send spike and heatwave messages to all affected users' do
          # 2 affected by spike in mildura
          # 2 affected by heatwave in mildura
          # 1 affected by spike in aireys
          is_expected.to have_attributes size: 5
        end
      end

      context 'with two heatwaves at different locations for one day' do
        let(:rules) { [@spike_rule, @wave_rule] }

        before(:example) do
          temp = @mildura.mean_for(start_date) + @spike_rule.delta - 1
          Weather.update_or_create_by(
            { location: @mildura, date: start_date }, high_temp: temp)
          temp = @mildura.mean_for(start_date + 1) + @spike_rule.delta - 1
          Weather.update_or_create_by(
            { location: @mildura, date: start_date + 1 }, high_temp: temp)
          temp = @mildura.mean_for(start_date + 2) + @spike_rule.delta - 1
          Weather.update_or_create_by(
            { location: @mildura, date: start_date + 2 }, high_temp: temp)
          temp = @aireys.mean_for(start_date) + @spike_rule.delta - 1
          Weather.update_or_create_by(
            { location: @aireys, date: start_date }, high_temp: temp)
          temp = @aireys.mean_for(start_date + 1) + @spike_rule.delta - 1
          Weather.update_or_create_by(
            { location: @aireys, date: start_date + 1 }, high_temp: temp)
          temp = @aireys.mean_for(start_date + 2) + @spike_rule.delta - 1
          Weather.update_or_create_by(
            { location: @aireys, date: start_date + 2 }, high_temp: temp)
        end

        it 'should send heatwave messages to all affected users' do
          # 2 affected by spike in mildura
          # 1 affected by heatwave in aireys
          is_expected.to have_attributes size: 3
        end
      end
    end

    describe '.triggerings' do
      subject { Messenger::Joiner.triggerings(models, rule, start_date) }
      let(:rule) { @rule || fail('no rule') }

      context 'with the heat spike rule' do
        before(:context) do
          @rule = @spike_rule
          make_weather # Set up the spikes per day as required.
        end

        context 'with no spike' do
          let(:start_date) { Date.today }
          it { is_expected.to be_empty }
        end

        context 'with one spike' do
          let(:start_date) { Date.today + 1 }
          it 'should have a message for the spike' do
            is_expected.to have_attributes size: 1
          end
        end

        context 'with two spikes' do
          let(:start_date) { Date.today + 2 }
          it 'should have a message for both spikes' do
            is_expected.to have_attributes size: 2
          end
        end
      end

      context 'with the heatwave rule' do
        before(:context) do
          @rule = @wave_rule
          make_weather # Set up the spikes per day as required.
        end

        context 'with no heatwave' do
          let(:start_date) { Date.today }
          it { is_expected.to be_empty }
        end

        context 'with a heat spike but no heatwave' do
          let(:start_date) { Date.today - 1 }
          it { is_expected.to be_empty }
        end

        context 'with one heatwave' do
          let(:start_date) { Date.today + 3 }
          it 'should have a message for the spike' do
            is_expected.to have_attributes size: 1
          end
        end

        context 'with two heatwaves' do
          let(:start_date) { Date.today + 6 }
          it 'should have a message for both spikes' do
            is_expected.to have_attributes size: 2
          end
        end
      end
    end

    describe '.recipients' do
      subject { Messenger::Joiner.recipients(rule, location) }

      let(:rule) { nil } # Currently the rule is not used.

      context 'when no users are in the location' do
        let(:location) { @woop_woop }
        it { is_expected.to be_empty }
      end

      context 'when one user is in the location' do
        let(:location) { @aireys }
        it 'is expected to have just that user as a recipient' do
          is_expected.to eq [@bob]
        end
      end

      context 'when many users are in the location' do
        let(:location) { @mildura }
        it 'is expected to have each user in the location as a recipient' do
          is_expected.to contain_exactly @alice, @carol
        end
      end
    end

    def make_weather
      (0..2).each { |i| make_weather_for(@mildura, i, i) }
      (0..2).each { |i| make_weather_for(@aireys, i, i - 1) }
      make_heat_spike(@aireys)
    end

    def make_weather_for(location, cycle, deltas)
      start = Date.today + cycle * @rule.duration
      finish = start + @rule.duration
      (start...finish).each do |d|
        temp = location.mean_for(d) + @rule.delta * deltas + 1
        Weather.update_or_create_by({ location: location, date: d },
                                    high_temp: temp)
      end
    end

    def make_heat_spike(location)
      date = Date.today - 1
      temp = location.mean_for(date) + @rule.delta * 2 + 1 # Fragile
      Weather.update_or_create_by({ location: location, date: date },
                                  high_temp: temp)
    end

    before(:context) do # Database
      Messenger::Database.initialise
      @mildura = Location.find_or_create_by(
        name: 'MILDURA RACECOURSE',
        jan_mean: 25.0, feb_mean: 22.1, mar_mean: 18.2, apr_mean: 14.3,
        may_mean: 12.4, jun_mean: 10.5, jul_mean: 8.6, aug_mean: 12.7,
        sep_mean: 14.8, oct_mean: 18.9, nov_mean: 20.0, dec_mean: 24.1)
      @aireys = Location.find_or_create_by(
        name: 'AIREYS INLET',
        jan_mean: 22.5, feb_mean: 20.4, mar_mean: 17.3, apr_mean: 12.2,
        may_mean: 9.1, jun_mean: 8.0, jul_mean: 7.9, aug_mean: 10.8,
        sep_mean: 11.7, oct_mean: 16.6, nov_mean: 19.5, dec_mean: 21.4)
      @woop_woop = Location.find_or_create_by(
        name: 'WOOP WOOP',
        jan_mean: 0.0, feb_mean: 0.0, mar_mean: 0.0, apr_mean: 0.0,
        may_mean: 0.0, jun_mean: 0.0, jul_mean: 0.0, aug_mean: 0.0,
        sep_mean: 0.0, oct_mean: 0.0, nov_mean: 0.0, dec_mean: 0.0)
      User.destroy_all
      @alice = User.create!(email: 'asanchez@email.com',
                            password: '12345678',
                            f_name: 'Alice',
                            l_name: 'Sanchez',
                            gender: 'F',
                            age: 20,
                            message_type: 'phone',
                            phone: '0400400000',
                            location: @mildura)
      @bob = User.create!(email: 'bobr@email.com',
                          password: '12345678',
                          f_name: 'Bob',
                          l_name: 'Roberts',
                          gender: 'M',
                          age: 30,
                          message_type: 'email',
                          location: @aireys)
      @carol = User.create!(email: 'cadav@email.com',
                            password: '12345678',
                            f_name: 'Carol',
                            l_name: 'Davids',
                            gender: 'F',
                            age: 40,
                            message_type: 'phone',
                            phone: '0400400234',
                            location: @mildura)
      @spike_rule = Rule.find_or_create_by(id: 1,
                                           name: 'Heat spike detection',
                                           activated: true,
                                           duration: 1,
                                           delta: 15,
                                           key_advice: 'spike key advice',
                                           full_advice: 'spike full advice')
      @wave_rule = Rule.find_or_create_by(id: 2,
                                          name: 'Heatwave detection',
                                          activated: true,
                                          duration: 3,
                                          delta: 10,
                                          key_advice: 'wave key advice',
                                          full_advice: 'wave full advice')
    end
  end
end
