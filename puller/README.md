# Puller

This gem provides an interface for pulling weather data using a
supplied weather getter, weather processor, and weather saver.

## Validation

Run the following shell command to validate the application:

```Ruby

$ cd $REPOSITORY_ROOT/puller
$ bundle exec rake validate

```

## Installation

Install the application through rake with the following commands:

```bash
$ cd $REPOSITORY_PATH/puller
$ bundle exec rake install
```

## Usage

Install the application using the instructions above.

To pull weather data in Victoria for the next week, run:

```bash
$ cd $ANY_DIRECTORY
$ puller relative/path/to/datastore
```

This will pull weather data from BoM, and extract the upcoming
maximum temperatures for each region, and save them to disk
in a binary format.
Any preexisting datastore in the same file will be overwritten.

To load the data in any Ruby script, use the following code:

```Ruby

data = Marshal.load(File.open('relative/path/to/datastore'))

```

The data will be loaded as a hash with:

* The BoM location IDs as the keys.
* An array of the maximum temperatures forcasted for the next 7 days
  at that location.

For example:

```Ruby

{
  90180 => [13, 15, 15, 14, 13, 14, 16],
  72146 => [15, 15, 17, 14, 17, 16, 17],
  # ...
}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec puller` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

