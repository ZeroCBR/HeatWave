# MailExample

A simple executable gem for demonstrating the `mail` api.

## How `mail` works

Load the `mail` gem:
```ruby
require 'mail'
```

Specify which smtp server is used and how it is accessed:
```ruby
    options = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'your.host.name',
      user_name:            details[:user_name],
      password:             details[:password],
      authentication:       'plain',
      enable_ssl:           true,
      enable_starttls_auto: true
    }
```

Tell `mail` to use the options defined above:
```ruby
    Mail.defaults do
      delivery_method :smtp, options
    end
```

Tell `mail` to send an email:
```ruby
    Mail.deliver do
      to details[:recipient]
      from details[:user_name]
      subject details[:subject]
      body details[:message]
    end
```

## Usage

From the `mail_example` directory, run the following commands:

```shell
% bin/setup # Set up the gem to be run.
% bin/console # Run the gem as a console application.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Tests aren't included; this is just an example script.
