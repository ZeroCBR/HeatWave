# SmsSender
This Gem acts as a wrapper for the Telstra Dev SMS api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sms_sender'
```

## Validation
from REPO?ROOT/sms_sender
    $ bundle exec rake validate

    and if you would like:

    $bundle exec rake test:acceptance


## Installation

Install the application through rake with the following commands:

```bash
$ cd $REPOSITORY_PATH/sms_sender
$ bundle exec rake install
```
Or install it yourself as:

$ gem install sms_sender

## Usage
Usage is performed by either calling the methods directly
or creating a class that wraps them (I have an example class in sms_sender.rb)

There are two important Methods:
.get_token takes our Client secret and ID and returns an access token
	the token is valid for one hour

.send_sms then takes that token, a number and a message and sends it to the API
	it returns the ID of the message, which will be used to match it with any \
	replies
