# Dev Utils

This project contains scripts, docker files, and other tools that I use to ease
development. Everything here was created by me, for me, to make my own
particular development workflow easier. Having said that, there are things here
that others might find useful, whether that be by adopting the workflow that
dev-utils enables wholesale, or just taking inspiration from various bits and
pieces.

## Requirements

All development applications are run as docker containers, so make sure you have
both **docker** and **docker-compose** installed.

Additionally, many of the scripts and configuration files expect that an
environment variable named `PROJECT_HOME` exists and points to the directory
where your repositories live, for `dev-utils` as well as any applications or
libraries that you are developing against. For example, if your `PROJECT_HOME`
is set to `/home/scott/dev`, then that directory might look something like the
following:

```shell
$ls -1 $PROJECT_HOME
beer-garden
brewtils
dev-utils
example-plugins
```

## Directories

The following is a brief description of what you'll find in the various
directories:

- **beer-garden:** Docker and application configuration specific to doing
  [beer-garden](https://github.com/beer-garden/) development.
- **certs:** Contains a root CA cert and key, as well as a
  [README](certs/README.md) with directions on how to use that CA cert to create
  signed certifiates.
- **docker-scripts:** Helper scripts that get mounted into the docker containers
  of applications.
- **linux-conf:** My personal configs for things like vim and tmux. If you are
  stubborn like me and use the command line for everything, some of these
  configs might be useful.
- **scripts:** General scripts not related to any specific application.

## Getting Started

See the individual README files for application specific details.

- [beer-garden](beer-garden/README.md)
