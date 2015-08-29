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

# The Rails Application

The following steps should be executed from the `heatwave`
top level directory in the repository.

## Windows

If using windows, perform the following steps (shell commands
should be entered in the MinGW shell):

1. Download [MinGW](http://mingw.org/) using
   [mingw-get-setup](http://sourceforge.net/projects/mingw/files/Installer/mingw-get-setup.exe/download).
   Mark for installation the packages:
    * mingw-developer-toolkit
    * mingw32-base
    * msys-base
   Install the packages using Installation > Apply Changes.
2. Install Ruby v2.1.6, RubyGems v2.4.5, and Rake using
   [RubyInstaller](http://rubyinstaller.org/).
3. Update your MinGW mirrorlist according to
   [https://github.com/Alexpux/MINGW-packages/issues/702].
   `$ vim /path/to/file` will allow you to edit files in the MinGW file tree.
4. Install the gcc bits for windows using (both):
    1. `$ pacman -S gcc`.
    2. `$ pacman -S mingw64/mingw-w64-x86_64-gcc`.
5. Install SQLite v3.8.8.2 using `$ pacman -S sqlite`.
6. Install other dependencies normally as specified below.

## Deployment

### Setup

1. Install [Ruby v2.2.3](https://www.ruby-lang.org/en/downloads/).
2. Install [RubyGems v2.4.8](https://rubygems.org/pages/download).
3. Install Bundler v1.10.6: `$ gem install bundler`
4. Install Rake: `$ gem install rake`
3. (subject to change)
   Install [SQLite3 v3.8.11.1](https://www.sqlite.org/releaselog/3_8_11_1.html)
4. Install Rails v4.2.4: `$ gem install rails`.
5. Install Rubocop v0.33.0: `$ gem install rubocop`.
6. Install dependencies through Bundler:
   `$ bundle install --path vendor/bundle --deployment`

### Execution

1. `$ bin/rails server`

## Development

TODO set up rails/rake environments

### Setup

1. Perform the setup steps for deployment.
2. Install development dependencies through Bundler:
   `$ bundle install --path vendor/bundle`.

### Linting

1. Run Rubocop with the Rails option: `$ rubocop -R`.

TODO integrate with rake

### Testing 

TODO integrate with rake

# Project Team

**Design Lead:** Borui Chen

**Project Manager:** James McMahon

**QA and Development Environment Lead:** Ned Pummeroy

**Requirements Lead:** Shengshuo Zhang

**Supervisor:** David (Knobby) Clarke
