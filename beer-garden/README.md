# beer-garden

The tools here make it easy to run development instances of Beer Garden,
including a parent garden and several remote (child) gardens that connect to it.
This guide will walk you through how to get everything configured and running.

## Requirements

See the [requirements](../README.md#requirements) section of the top level
README.

Additionally, the instructions that follow will assume that the `beer` script
contained in the scripts folder is in your environment `PATH`. If it is not, be
sure to substitute the full path anywhere you see `beer` in the directions.

## Building the Docker Images

Before you can start things, you'll need to build the the docker images. This
can be done by running:

```shell
beer build
beer buildui
```

There are also build commands for the React based UI and a remote plugin image,
which you can optionally run as well:

```shell
# These are not required for standard development
beer buildreact
beer buildplugin
```

## Starting the Docker Containers

To start a single garden (the parent) and all dependent services, just run:

```shell
beer up
```

To start an individual child garden, just specify the garden name:

```shell
beer up <garden_name>
```

To start everything, including all child gardens and the React UI for the
"parent1" garden, run:

```shell
beer up all
```

**Note:** No user accounts are available upon garden creation. If you have auth
enabled, your plugins may initially fail to connect to the garden. If this
happens [load the user account data](#loading-useful-data) after your garden
initially starts, then restart your garden.

## Stopping and Restarting

You can bring down the entire docker stack via:

```shell
beer down
```

This will stop and remove all of the running containers. It will not remove any
docker volumes, which allows data, such as your mongo database, to persist even
after the containers are removed. If you want a totally clean start, you can
remove the docker volumes as well:

```shell
beer down
docker volume prune
```

There is currently no shortcut for stopping an individual container. To do that,
use the standard docker commands.

```shell
docker stop bg-parent1
```

To restart the container for a garden:

```
beer restart <garden_name>
```

If no garden is specified the "parent1" garden will be restarted.

## Loading Useful Data

A helper script can be run to load a handful of user accounts and configure the
child garden connections for the "parent1" garden.

```shell
beer load
```

This will create the following users, all sharing the same password: "password".

- p1reader: Read only access to the parent1 garden
- p1c1reader: Read only access to parent1 and child1
- echooperator: Operator access for systems names "echo" across all gardens
- admin: Superuser access on all gardens

**Note:** These user accounts are intentionally distinct from the ones with
[certificates](#user-certificates). This was done to make it more clear what is
being tested when logging in via certificates versus a username and password.

## Garden Config

The configuration files for the gardens are stored in the `conf/` directory. The
files you'll find there are:

- **app-logging.yaml:** Sets the various logging levels for the garden. This
  config is currently shared across all gardens.
- **bg-\<garden\>.yaml:** Individual application configs for each garden.
- **groups.yaml:** This is used by the nginx proxy to map a user's groups to
  internal beer-garden role assignments.
- **plugin-logging.yaml:** Logging settings for the plugins run by the gardens.
  This is currently shared across all gardens.
- **requirements.local.txt:** Allows local libraries to be used in place of the
  installed packages inside the containers. Additional details on this are
  available in the section on [using local libraries](#using-local-libraries).
- **roles.yaml:** Defines the roles that will be available in your gardens and
  what permissions those roles have associated with them.
- **webpack.bg-\<garden\>.js:** Webpack config that is used by the corresponding
  garden's UI container.
- **nginx:** This folder contains configuration used by the nginx ssl proxy.

A shortcut is available for opening the main application config in vim:

```
beer conf <garden_name>
```

## Browser Access

The UI for the parent1 garden is available at the following addresses:

- http://localhost:8080
- https://localhost:8000

The https address must be used if auth is enabled on your garden and you want to
authenticate using certificates. More detail on using certificates is
[available here](#user-certificates).

**Tip:** If you are using certificate authentication, putting your browser in
private or incognito mode is the easiest way to switch between certificates.
Every time you close your private browser session and start a new one, you will
be prompted to select your certificate again.

## Python Shell Access

It is often useful to get open a shell to be able to interact with your garden
via python. To do this:

```shell
beer pyshell <garden_name>
```

If no garden name is specified, the default is "parent1".

The shell that you are dropped into here has a bunch of conveniences setup for
use.

- The mongoengine connection to your gardens database is already established.
- All of the beer-garden models are already imported.
- beer_garden.config is imported.
- An EasyClient instance is already setup under the variable `ec`.
- A RestClient is also setup under the variable `rc`.

**Note:** The EasyClient and RestClient are setup without authentication. If
auth is enabled on your garden, additional setup will be needed to use these.

## API Access

The swagger docs for the Beer Garden API will be available
[here](http://localhost:8080/swagger/index.html?config=/config/swagger).

There is also a command line api helper available that be used as follows:

```shell
  beer api <endpoint>
```

For example:

```shell
# Retrieve all gardens
beer api gardens

# Retrieve a specific System
beer api systems/624ef90394bf0626ce368204
```

You can also do POST and PATCH operations:

```shell
beer post users '{"username": "joeuser", "password": "password"}'
beer patch jobs/6255ba7981e7bb48ffdbdad2 '{ "operation": "update", "path": "/status", "value": "PAUSED" }'
```

These api helpers require an authentication token, which can be created for use
by doing:

```shell
beer login <username>
```

The username provided must be a user for which there is a certificate present in
the beer-garden/certs folder.

## Debugging

[Remote-Pdb](https://pypi.org/project/remote-pdb/) is installed in the garden
containers and the appropriate ports are exposed to allow you to connect to the
debugger. Simply insert python's built in `breakpoint()` command before the line
you would like to stop at and then restart your garden.

Once the breakpoint has been triggered, you can use telnet to connect to the
debugger like so:

```shell
telnet localhost 3333
```

The port number varies per garden:

- 3333 - parent1
- 4444 - child1
- 5555 - child2
- 6666 - child2-grandchild1

## Using Local Libraries

In cases where you are developing changes to brewtils and want to run your
beer-garden instance using your locally checked out copy of brewtils, you can
add brewtils to the `conf/requirements.local.txt` file. Then start or restart
your garden and brewtils will be loaded from `$PROJECT_HOME/brewtils` rather
than the version pip installed in the container. For example:

```shell
# Switch to using locally checked out brewtils
cd $PROJECT_HOME/dev-utils/beer-garden/conf
echo brewtils > requirements.local.txt
beer restart

# Revert back to using the pip installed version
echo "" > requirements.local.txt
beer restart
```

## Certificates

The certs directory contains a collection of certificates that can be used
during development of Beer Garden. The included certificates are described
below.

### Proxy certificate

The `proxy.crt` and `proxy.key` are for use with the nginx SSL proxy. The nginx
container that is started by the `docker-compose.yml` will use these.

The certificate is configured with several aliases so that it will pass
verification in different contexts:

- proxy
- localhost
- 127.0.0.1

### User certificates

The remaining certificates are all intended to be used as user certificates,
allowing for testing of users with different roles and permissions assigned. The
certificates are named according to the username, which is intended to be
descriptive of level of access. The users are:

- allreader: Read only access to all gardens
- bgadmin: Superuser access to all gardens
- c1reader: Read only access to the "child1" garden
- p1operator: Operator access to the "parent1" garden

Each user has a `.crt`, `.key`, and `.p12` file. The `.crt` and `.key` can be
used for configuring access for a plugin or EasyClient connection, while the
`.p12` file can be imported into a browser and used to authenticate to the UI.

## Known Issues

The following are a list of known issues that will likely be addressed in the
future.

- As previously mentioned, plugins may fail to start initially due to user
  accounts not being created prior to initial startup.
- The UI containers are slow to start and do not have live reloading. This makes
  iterating on UI changes slower than it ought to be.
