melbourne = Location.create(id: 86071,
                            name: 'MELBOURNE REGIONAL OFFICE',
                            jan_mean: 25.9,
                            feb_mean: 25.8,
                            mar_mean: 23.9,
                            apr_mean: 20.3,
                            may_mean: 16.7,
                            jun_mean: 14.1,
                            jul_mean: 13.5,
                            aug_mean: 15.0,
                            sep_mean: 17.3,
                            oct_mean: 19.7,
                            nov_mean: 22.0,
                            dec_mean: 24.2)

User.create(email: 'heatwaveorange@gmail.com',
            password: 'heatwaveorange1234',
            admin_access: true,
            location: melbourne,
            f_name: 'Heatwave',
            l_name: 'Administrator',
            gender: 'An enigma',
            age: 99,
            message_type: 'email')

full_advice = \
  'The rule name identifies the rule and is the heading of its advice page. '\
  'The key advice is sent in email and sms messages to users, and is '\
  'displayed prominently on the advice page. '\
  "The full advice is only displayed on the advice page.\n"\
  \
  'Heatwave administrators can also view the rule duration and delta. '\
  'The delta is the minimum temperature above the average that has to be '\
  'observed before a rule is triggered. The duration is the number of '\
  'days in a row that the delta requirement must be satisfied for the '\
  "rule to be triggered.\n"\
  \
  'When a rule is triggered, messages are sent to all users in the triggering '\
  "location, via their prefered messaging service.\n"\
  \
  'This rule is not activated. This means that messages are not sent, '\
  'even when it is triggered. However, its advice page is still public, '\
  "so if you don't want users to see this, you should update this rule's "\
  "advice using an admin account before you go live!\n"\
  \
  'One more thing; we recommend that you make some practice rules and '\
  'user accounts before going live. That way, you see what the messages '\
  'look like yourselves! You can make sure that rules are triggered by '\
  "setting their delta to a very low number, like -20.\n"\

Rule.create(name: 'Heatwave alert!',
            activated: false,
            delta: 10,
            duration: 3,
            key_advice: 'Please update this rule!',
            full_advice: full_advice)
