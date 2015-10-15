# HeatWave-Orange

This is the Orange team's source code repository for the HeatWave
project.

HeatWave is an extreme weather warning system produced for Kildonan
UnitingCare.
It will provide warning SMS and email messages to registered
vulnerable individuals in the event of extreme weather conditions,
such as heat waves.

This project is being completed in semester 2 of 2015 for The
University of Melbourne subject SWEN90014 Masters Software
Engineering Project.

# Deployment

To try out the system, simply run the following shell command
from the repository root:

`$ ./install && ./validate && ./run`

This will allow you to quickly identify any missing dependencies or
problems with the setup, and get an idea for how the system works.

Afterwards you can configure the system to your liking.

## Simple Setup

**If using windows**, see the `## Windows` section below before installing.

Installation, validation, and the application itself can be run via
scripts in the repository root.

`$REPOSITORY_ROOT` stands for wherever the repository is cloned to.

**Installation:** `$REPOSITORY_ROOT/install`
**Validation:** `$REPOSITORY_ROOT/validate`
**Execution:** `$REPOSITORY_ROOT/run`

The scripts assume that they will be run with `$PWD` being `$REPOSITORY_ROOT`.

The installation script will also populate the database with a few
very simple records:

* An administrator account.
* A location, the MELBOURNE REGIONAL OFFICE weather station.
* An example rule, with advice explaining how the rules
  relate to weather, what determines the message content sent to
  users, and what users can see on the website.

## Initial Administrator Account

The initial administrator account has the following login details:

**Email:** heatwaveorange@gmail.com
**Password:** heatwaveorange1234

These details can be set at the very top of the ./install script.

This account can be used to set up accounts for real users and admins.
It is recommended that this account be unregistered eventually for
security purposes, but remember to make another admin account first!

## Basic Configuration

It is recommended that (at least to begin with), you try the simple setup
scripts described above without changing them.
However before making this system available to the public, there are
particular configuration options that must be reviewed and changed.

### Rails Server Runtime Configuration

In the `run` script, three variables are defined at the top,
which form the final runtime configuration for rails.

`SECRET_KEY_BASE`:
The secret key needs to be set for production mode.
It is used for validating cookies for sessions, etc.
It can be changed freely but doing so will invalidate cookies
(such as for saved sessions).

`BINDING_ADDRESS`:
A binding address of 0.0.0.0 is required for the rails server
to be able to receive connections over a network (as opposed to
just from the same computer).

`PORT`:
The server will listen on this port.
You may wish to change it (for example, to port 80 or another port),
depending on how the server will fit in with your existing systems.

### Simple Setup Scripts

The three scripts for installation, validation, and execution mentioned
above define several environment variables.
If for any reason the directory structure of the application
needs to be changed, those environment variables provide a way
of specifying the changes for the software system.

### Configuration Files

`$REPOSITORY_ROOT/heatwave/config/environments/production.rb`:

* The URL to use for emailed links for account management purposes
  is specified near the top of the file.  More precise instructions
  are in that file.
* The email account and server to use for account management emails
  is specified in the same location.

`$REPOSITORY_ROOT/heatwave/config/initializers/devise.rb`:

* The email sender (which appears in the 'from' field of emails)
  is specified near the top of the file.  More precise instructions
  are in that file.

`$REPOSITORY_ROOT/messenger/lib/messenger/email_wrapper.rb`:

* The SMTP server from which to send heatwave alert emails is configured
  by editing `Messenger::EmailWrapper::options_for(..)`.
* The email account with which to log in to the SMTP server is configured
  by editing `Messenger::EmailWrapper::create_email_details(..)`.

`$REPOSITORY_ROOT/sms_sender/lib/sms_sender.rb`:

* The Telstra developer API account with which to send heatwave alert SMSs is
  configured by editing `ExampleSender::CLIENT_ID` and
  `ExampleSender::CLIENT_SECRET`.

## Windows

If using Windows, then before running the install script,
perform the following steps (shell commands should be entered
in the **MSYS** shell):

1. Install [MSYS](https://msys2.github.io/).
2. Install Ruby v2.1.6, RubyGems v2.4.5, Rake, and build dependencies
   using [RubyInstaller and Ruby DevKit](http://rubyinstaller.org/downloads).
3. Add the Ruby DevKit's bin directory to your bash (MSYS) $PATH
   environment variable.
4. Install [Node.js v4.0.0+](https://nodejs.org/).
5. Install gcc using:
   * `$ pacman -S gcc`
   * `$ pacman -S mingw64/mingw-w64-x86_64-gcc`
7. Install other dependencies normally as specified below.

# Contributing

To contribute to this project, make a JIRA issue for whatever
you're working on, clone the repository, make a new branch,
and start working.

## Branching

The `master` branch is the most up to date correct branch.

When implementing a new feature, checkout a new branch from the
current `master` using the naming convention `username/feature-name`.

For example, for Ned to implement a landing page, he should create a
new branch called `nedp/landing-page`.

When the feature is done, first **rebase** the feature branch
on using the tip of the current `master` branch.
This ensures an untangled history.

Then, if there isn't already a JIRA issue for the feature/task,
create one.
Set the issue's status to `In Review`; this makes it clear that
everyone is expected to check the branch.

When an issue corresponding to a branch is in review, everyone
should check over the diffs from the current `master` branch,
and leave suggestions for the branch author by commenting on
the issue.

After **all** feedback has been responded to, then everyone
including the branch author should 'sign off' on the issue
by posting a comment saying '+1'.

After three people **including** branch author have signed off like
this, the **author** should do a fast forward merge of the feature
branch into the `master` branch.
This ensures that the majority of the team is happy with all `master`
code, without holding the entire project up if one person is
unavailable.

Since we will be working on many features simultaneously, everyone
should endeaver to keep their branches up to date by rebasing onto
the latest `master` branch whenever new commits are added to it.

## Coding Style

Make every effort to adhere to
[the community driven Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)
for Ruby code, as well as
[the Rails Style Guide](https://github.com/bbatsov/rails-style-guide)
for the Ruby on Rails application.

Use both Rubocop and other team members' code reviews to verify this.
Committing to `master` without justifying all deviations from the styleguide
will result in commits being reverted.

## Gems

The project is split into gems with minimal coupling between them.

Create a gem using bundle from the repository root:

```bash
% bundle gem gem_name
```

## Dependencies

Gems should specify their dependencies in the gemspec,
Gemfile, and Gemfile.lock, depending on the type of gem.

Development dependencies (eg. build or testing tools)
should be included in `gem_name.gemspec` using, for example:
```ruby
spec.add_development_dependency "bundler", "~> 1.10"
```
The gemspec file should always be checked in.

Anything which is a standalone executable should specify
their dependencies in `Gemfile.lock`, which should be checked in.

Anything which is a library should specify its dependencies in
the `gem_name.gemspec`, which should be checked in.
`Gemfile.lock` should not be checked in for libraries.

## Rake

Rake should be used to manage build tasks.

All gems outside the rails app should include the following tasks,
in addition to the built in tasks.

* `test` -- runs the gem's tests.
* `rubocop` -- runs Rubocop on the gem.
* `validate` -- runs Rubocop and all tests for the gem.

## Testing

All units should be tested at least to some extent.
Committing any complex code to `master` without adding new tests
and/or updating old tests will result in commits being reverted.

In general, we use a test file for each source file.

Tests may use whatever framework you wish, but it is
suggested that you start with `Test::Unit`, since it is
built in and straightforward.

Tests must be runnable by calling `% bundle exec rake test`
from the gem directory.
This task should include any setup tasks required for running
the tests.
This ensures that running tests is not a painful process.

# Project Team

**Design Lead:** Borui Chen

**Project Manager:** James McMahon

**QA and Development Environment Lead:** Ned Pummeroy

**Requirements Lead:** Shengshuo Zhang

**Supervisor:** David (Knobby) Clarke

# Troubleshooting

## Ruby version is less than 2.0.0 on Ubuntu.

Install Ruby using rvm instead.

`$ sudo apt-get rvm`

## Installation stops after refusing to allow a dependency to install.

You need to accept all installation prompts, or modify the
installation script to use suitable alternatives.

## Failed to build artifacts using native extensions.

Make sure that gcc, Ruby development packages (depending on your OS),
and Node.js are all installed.
