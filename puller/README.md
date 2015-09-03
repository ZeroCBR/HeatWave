# Puller

This gem provides an interface for pulling weather data using a
supplied weather getter, weather processor, and weather saver.

## Acceptance Testing

The `test:acceptance` rake task will run the puller with human
readable output for acceptance testing.

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
$ puller
```

This will pull weather data from BoM, and extract the upcoming
maximum temperatures for each region, marshal the result,
and print it to stdout.

To load the data in any Ruby script, use the following code:

```Ruby
data = Marshal.load(marshalled_string)
```

`marshalled_string` should be a string which was loaded,
for example through stdin by piping from puller:

```bash
$ puller | my_script.rb
```

or by reading a file which puller output was redirected to:

```bash
$ puller > data_store
$ my_script.rb < data_store
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
