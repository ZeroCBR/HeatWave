# Puller

This gem provides an interface for pulling weather data using a
supplied weather getter, weather processor, and weather marshaler.

## Acceptance Testing

There are three rake tasks for acceptance testing, all with human
readable results showing the database state:

* `$ rake test:acceptance:weather` runs the weather puller
* `$ rake test:acceptance:location` runs the location puller
* `$ rake test:acceptance` runs all of the above tasks.

```shell
$ cd $REPOSITORY_ROOT/puller
$ bundle exec rake test:acceptance
```

## Validation

Run the following shell command to validate the application:

```shell
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
$ puller location # fill the Location database table
$ puller # pull weather data for all known locations to the database.
```

This will pull weather data from BoM, and extract the upcoming
maximum temperatures for each region, marshal the result,
and print it to stdout.
