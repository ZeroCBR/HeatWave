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

# Project Team

**Design Lead:** Borui Chen

**Project Manager:** James McMahon

**QA and Development Environment Lead:** Ned Pummeroy

**Requirements Lead:** Shengshuo Zhang

**Supervisor:** David (Knobby) Clarke
