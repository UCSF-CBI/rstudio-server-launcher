[![shellcheck](https://github.com/UCSF-CBI/rstudio-server-controller/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/UCSF-CBI/rstudio-server-controller/actions/workflows/shellcheck.yml)

# RStudio Server Controller (RSC)

This is a shell tool for conveniently launching a personal instance of
the [RStudio Server] on a Linux machine, which then can be access in
the local web browser, either locally, or remotely via SSH tunneling.
RStudio is an integrated development environment (IDE) for [R].


## Features

### User experience

* It is easy to start and stop the RStudio Server, e.g. `rsc start`
  and `rsc stop`

* Any user can run it, i.e. it requires no special privileges

* It gives cut'n'paste instructions on how to access a remote RStudio
  Server instance via SSH tunneling through a login host

* It is possible to expose the RStudio Server port on a remote machine
  via reverse SSH tunneling,
  e.g. `--revtunnel=<user>@<remote-hostname>:<remote-port>`

* It provides convenient alternatives for setting the port where
  RStudio Server is hosted, e.g. `--port=port4me` and
  `--port=<fix-port>`.

* R sessions can inherit the environment variables from the shell
  launching the RStudio Server, e.g. all variables by
  `--env-pattern="^.*$"` (default), or a subset as
  `--env-pattern="^(R_.*|SLURM_.*)$"`

### Authentication

* There are multiple options for how the RStudio Server login is
  authenticated. The default,
  [`--auth=auth-via-su`](https://github.com/UCSF-CBI/rstudio-server-controller/blob/main/bin/utils/auth-via-su),
  relies on `su` to authenticate using the system's authentication
  method. An alternative to this, is
  [`--auth=auth-via-ssh:<hostname>`](https://github.com/UCSF-CBI/rstudio-server-controller/blob/main/bin/utils/auth-via-ssh),
  which authenticates using SSH towards host `<hostname>`. If neither
  are an option, [`--auth=auth-via-env
  --random-password`](https://github.com/UCSF-CBI/rstudio-server-controller/blob/main/bin/utils/auth-via-env)
  can be used to authenticate with a one-time, temporary password that
  is echoed. If `--random-password` is not specified for the latter,
  then the password is taken from environment variable `RSC_PASSWORD`,
  which is _not_ echoed.  It is also possible to use a custom
  authentication helper, e.g. `--auth=<command-on-PATH>` and
  `--auth=<file>`


### Stability

* A user can run at most one RStudio Server instance on a multi-host
  system, which minimized the number of stray instances being left
  behind

* The RStudio Server will time out ten minutes after the most recent R
  session was terminated. This prevents stray RStudio Server processes
  being left behind
  
* The default timeout for an idle R session is two hours

* The tool attempts to be agile to different POSIX signals to shut
  down everything when the RStudio Server instance is terminated,
  e.g. by `SIGINT` from <kbd>Ctrl-C</kbd>, `SIGQUIT` from
  <kbd>Ctrl-\\</kbd>, or a `SIGUSR2` notification signal by a job
  scheduler


## Running RStudio Server locally

To launch your personal RStudio Server instance, call:

```sh
$ rsc start
alice, your personal RStudio Server 2023.03.0+386 running R 4.3.1 is available on:

  <http://127.0.0.1:20612>

Any R session started times out after being idle for 120 minutes.
WARNING: You now have 10 minutes, until 2023-04-17 17:30:33+01:00, to connect
and log in to the RStudio Server before everything times out.
```

The RStudio Server can then be accessed via the web browser at
<http://127.0.0.1:20612>.  The default port number is generated by the
[port4me] algorithm, which looks for a free port that is unique to
each user and stable over time. In the case when a user's default port
is already occupied, another, deterministic, user-specific port is
checked, and so on, until a free port is found.

The `rsc start` command will run until terminated,
e.g. <kbd>Ctrl-C</kbd>:

```sh
 $ rsc start
alice, your personal RStudio Server 2023.03.0+386 running R 4.3.1 is available on:

  <http://127.0.0.1:20612>

Any R session started times out after being idle for 120 minutes.
WARNING: You now have 10 minutes, until 2023-04-17 17:30:33+01:00, to connect
and log in to the RStudio Server before everything times out.
^C
Received a SIGINT signal
Shutting down RStudio Server ...
Shutting down RStudio Server ... done
```

Alternatively, the RStudio Server instance can be terminated by calling:

```sh
$ rsc stop
RStudio Server stopped
```

which sends a `SIGTERM` signal asking the different RStudio Server
processes to shut down nicely.  This is attempted multiple times.  As
a last resort, it will send `SIGKILL`, which kills the processes
abruptly.  If this command is not called from the same machine as from
where `rsc start` was called, then it will attempt to SSH to that
machine to terminate the RStudio Server.

A user can only launch one instance.  Attempts to start more, will
produce an informative error message, e.g.

```sh
$ rsc start
ERROR: alice, another RStudio Server session of yours is already running on
alice-notebook on this system. Call 'rsc status --full' for details on how
to reconnect. If you want to start a new instance, pleas e terminate the
existing one first by calling 'rsc stop' from that machine.
```

This limit applies across all machines on the same file system, which
helps keep multi-tenant high-performance compute (HPC) environments
tidy.

To check if another RStudio Server instance is already running, use:

```sh
$ rsc status
rserver: running (pid 29062) on current machine (alice-notebook)
listening on port 20612
rsession: not running
rserver monitor: running (pid 29101) on machine (alice-notebook)
lock file: exists (/home/alice/.config/rsc/pid.lock)
```

As the above error message suggests, add `--full` to also get information
on how to reconnect to the already running RStudio Server instance.


## Running RStudio Server remotely

### Scenario 1: Direct access to remote machine

Assume you have a remote server that you connect to via SSH as:

```sh
[ab@local ~]$ ssh -l alice server.myuniv.org
[alice@server ~]$
```

If we launch `rsc` on the remote server, we will get:

```sh
[alice@server ~]$ rsc start
alice, your personal RStudio Server 2023.03.0+386 running R 4.3.1 is available on:

  <http://127.0.0.1:20612>

Importantly, if you are running from a remote machine without direct access
to server.myuniv.org, you need to set up SSH port forwarding first, which you
can do by running:

  ssh -L 20612:server.myuniv.org:20612 alice@server.myuniv.org

in a second terminal from you local computer.

Any R session started times out after being idle for 120 minutes.
WARNING: You now have 10 minutes, until 2023-04-17 17:30:33+01:00, to connect
and log in to the RStudio Server before everything times out.
```

If we follow these instructions set up a _second_, _concurrent_ SSH
connection to the remote server:

```sh
[ab@local ~]$ ssh -L 20612:server.myuniv.org:20612 alice@server.myuniv.org
[alice@server ~]$
```

we will be able to access the RStudio Server at
<http://127.0.0.1:20612> on our local machine.  This works because
port 20612 on our local machine is forwarded to port 20612 on the
remote server, which is where the RStudio Server is served.

_Comment_: To use a separate port for the local machine in these
instructions, use command-line option `--localport=<port>`.


### Scenario 2: Indirect access to remote machine via a login host

Assume you can only access the remote server via a dedicated login
host:

```sh
[ab@local ~]$ ssh -l alice login.myuniv.org
[alice@login ~]$ ssh -l alice server.myuniv.org
[alice@server ~]$
```

If we launch `rsc` on the remote server, we will get very similar
instructions:

```sh
[alice@server ~]$ rsc start
alice, your personal RStudio Server 2023.03.0+386 running R 4.3.1 is available on:

  <http://127.0.0.1:20612>

Importantly, if you are running from a remote machine without direct access
to server.myuniv.org, you need to set up SSH port forwarding first, which you
can do by running:

  ssh -L 20612:server.myuniv.org:20612 alice@login.myuniv.org

in a second terminal from you local computer.

Any R session started times out after being idle for 120 minutes.
WARNING: You now have 10 minutes, until 2023-04-17 17:30:33+01:00, to connect
and log in to the RStudio Server before everything times out.
```

In this case, we do:

```sh
[ab@local ~]$ ssh -L 20612:server.myuniv.org:20612 alice@login.myuniv.org
[alice@login ~]$
```

After this, the RStudio Server is available at
<http://127.0.0.1:20612> on our local machine.  This works because
port 20612 on our local machine is forwarded to port 20612 on the
remote server, which is where the RStudio Server is served, via the
login host.


### Can we achieve the same with a single SSH connection?

Note that, the reason why we have to use two concurrent SSH
connections, is that we cannot know what ports are available when we
connect the first time to launch the RStudio Server.  If we could know
that, or if we would take a chance that it's available to use, we
could do everything with one connections.  For example, we have used
port 20612 several times before, so we will try that this time too:

```sh
[ab@local ~]$ ssh -L 20612:server.myuniv.org:20612 alice@login.myuniv.org
[alice@login ~]$ ssh -l alice server.myuniv.org
[alice@server ~]$ rsc start --port=20612
alice, your personal RStudio Server 2023.03.0+386 running R 4.3.1 is available on:

  <http://127.0.0.1:20612>

Importantly, if you are running from a remote machine without direct access
to server.myuniv.org, you need to set up SSH port forwarding first, which you
can do by running:

  ssh -L 20612:server.myuniv.org:20612 alice@login.myuniv.org

in a second terminal from you local computer.

Any R session started times out after being idle for 120 minutes.
WARNING: You now have 10 minutes, until 2023-04-17 17:30:33+01:00, to connect
and log in to the RStudio Server before everything times out.
```

As before, the RStudio Server is available at
<http://127.0.0.1:20612>.


### Scenario 3: Remote machine with direct access to our local machine

Assume you can SSH to the remote server, directly or via a login host,
and that the remote server can access your local machine directly via
SSH.  This is an unusual setup, but it might be the case when your
local machine is connected to the same network as the server, e.g. a
desktop and compute cluster at work.  In this case, we can ask `rsc`
to set up a _reverse_ SSH tunnel to our local machine at the same time
it launches the RStudio Server;

```sh
[ab@local ~]$ ssh -l alice server.myuniv.org
[alice@server ~]$ rsc start --revtunnel=ab@local.myuniv.org:20612
alice, your personal RStudio Server 2023.03.0+386 running R 4.3.1 is available on:

  <http://127.0.0.1:20612>

Any R session started times out after being idle for 120 minutes.
WARNING: You now have 10 minutes, until 2023-04-17 17:30:33+01:00, to connect
and log in to the RStudio Server before everything times out.
```

As before, the RStudio Server is available at
<http://127.0.0.1:20612>.


## Requirements

* Linux

* Bash

* R (<https://www.r-project.org>)

* RStudio Server (<https://www.rstudio.com/products/rstudio/#rstudio-server>)

* Netcat `nc` or socket statistics `ss` to check whether a TCP port is
  available or not - needed by `--port=port4me` (default)

* `expect` (<https://core.tcl-lang.org/expect/index>) - needed by the
  `auth-via-ssh` method, and, depending on system and `su`
  implementation, also by `auth-via-su`


## Installation

```sh
$ cd /path/to/software
$ curl -L -O https://github.com/UCSF-CBI/rstudio-server-controller/archive/refs/tags/0.13.9.tar.gz
$ tar xf 0.13.9.tar.gz
$ PATH=/path/to/softwarerstudio-server-controller-0.13.9/bin:$PATH
$ export PATH
$ rsc --version
0.13.9
```

To verify that the tool can find R and the RStudio Server executables,
call:

```sh
$ rsc --version --full
rsc: 0.13.9
RStudio Server: 2023.06.2+561 (Mountain Hydrangea) for Linux [/path/to/rstudio-server/bin/rstudio-server]
R: 4.3.1 (2023-06-16) -- "Shortstop Beagle" [/path/to/R/bin/R]
```


[R]: https://www.r-project.org/
[RStudio Server]: https://www.rstudio.com/products/rstudio/#rstudio-server
[port4me]: https://github.com/HenrikBengtsson/port4me
