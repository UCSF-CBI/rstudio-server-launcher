## Version 0.16.1 [2024-08-20]

### Miscellaneous

 * Now the error message that `rsc stop` produces when it failed to
   stop an RStudio Server instance running on another machine, will
   report on both the machine where it thinks RStudio is running and
   the current machine.
 
 * Now `rsc` assert that all files it creates are non-empty. This
   helps troubleshooting obscure errors, e.g. when user runs out of
   disk space.

### Bug Fixes

 * `rsc start --debug` could give an `operand expected (error token is
   "<pid>")` error on some systems.

### Deprecated and defunct

 * `--port=random` and `--port=uid` are defunct.


## Version 0.16.0 [2024-02-01]

### New Features

 * Now `rsc start` asserts that there are no stray 'rsession'
   processes running.
 
 * Now `rsc status` warns about stray 'rsession' processes.
 

## Version 0.15.1 [2024-01-25]

### New Features

 * `rsc config` now also reports on RStudio User Configuration,
   e.g. the user preferences `rstudio-prefs.json` file.
   
 * `rsc config` and `rsc status` now report on file sizes and
   modification timestamps.


## Version 0.15.0 [2024-01-16]

### New Features

 * Now `rsc config` reports also on `RSC_*` environment variables.
 
 * The default name of the login hostname suggested in remote SSH
   sessions can now be set via environment variable
   `RSC_SSH_LOGIN_HOSTNAME`.  The default is still to infer it from
   `who`.

### Miscellaneous

 * `rsc start --dryrun` is now shortened to 10 seconds.

### Bug Fixes

  * When adding option `--debug` to `rsc start` the RStudio Server
    failed to launch.


## Version 0.14.4 [2024-01-16]

### Bug Fixes

 * `rsc start` would generate obscure errors such as `ports.sh: line
   15: [[:` and `port4me.bash: line 275: 3: Bad file descriptor`.
   This was due to a teeny, but critical bug in **port4me**
   0.7.0. Fixed by updating to new **port4me** 0.7.1.
 

## Version 0.14.3 [2024-01-15]

### New Features

 * `rsc start --password=random` now generates a password that can be
   copied by double-clicking on it.  Technically, the password is now
   in a Base64 URL-safe encoding, whereas in the past it was Base64.

### Bug Fixes

 * `rsc start` would something fail to identified a TCP port as
    non-available, which resulted in an error from RStudio Server
    failing to launch. Fixed problem by updating to **port4me** 0.7.0
    internally.
 

## Version 0.14.2 [2023-10-23]

### Miscellaneous

 * `rsc start`, `rsc stop`, `rsc status`, `rsc reset`, etc. give more
   informative error messages when the machine where RStudio Server
   was most recently running on is not longer available.
 
 * `rsc start --force` suggests calling `rsc reset --force` as a last
   resort if the machine, where RStudio Server was most recently
   running on, is not longer available.
 

## Version 0.14.1 [2023-10-16]

### Miscellaneous

 * `rsc start` reports also on the port used, if it fails.


## Version 0.14.0 [2023-10-16]

### New Features

 * If `rsc start` finds an `.RData` file, it will warn that R might
   fail to launch if the file is very large.

 * Now `rsc` produces an informative warning whenever it needs to SSH
   into another host to check whether a specific process is running
   there or not.  This helps clarifying why users without SSH key-pair
   authentication setup have to enter their account password.

### Miscellaneous

 * Report also on the current host when `rsc` fails.
 

## Version 0.13.10 [2023-10-10]

### Bug Fixes

 * Authentication methods `--auto=auth-via-su` (default) and
   `--auto=auth-via-ssh` did not handle passwords starting with a
   hyphen (`-`), or that contained one or more dollar signs (`$`) or
   double quotation marks (`"`), if and only if, the `expect` command
   was installed on the system.  A user who entered such as password
   in the 'Sign in to RStudio' panel would always get an `Invalid
   authentication (incorrect password)` error.


## Version 0.13.9 [2023-10-09]

### Bug Fixes

 * Previous bug fix did not work; the time-out error never took place.
   

## Version 0.13.8 [2023-10-09]

### Bug Fixes

 * `rsc start` and `rsc status` would stall if the RStudio Server was
   previously running on another host and that host no longer responds
   on SSH.  Now it will timeout with an informative error message.
 

## Version 0.13.7 [2023-10-04]

### Miscellaneous

 * `rsc start` attempts to infer the login hostname from ``etc/hosts`,
   if it only finds an IP number at first.

 * `rsc start` now uses [port4me] 0.6.0, which is the most recent
   version, for identifying a free TCP port.
 

## Version 0.13.6 [2023-06-22]

### Miscellaneous

 * `rsc start` now reports also on the underlying error message if one
   of the assertion tests for the R installation being functional
   fails.


## Version 0.13.5 [2023-05-06]

### Bug Fixes

 * Shorten the path lengths of the RStudio Server `server-data-dir` and
   database `directory` folders by 17 characters.


## Version 0.13.4 [2023-04-17]

### New Features

 * Now the default path to the internal RStudio Server data directory
   can be configured via environment variable
   `_RSC_RSERVER_DATA_DIR_`. This can be used as a workaround when the
   default data directory path is too long, which results in error
   `[rserver] ERROR Unexpected exception: File name too long
   [system:36]; LOGGED FROM: int main(int, char* const*)
   src/cpp/server/ServerMain.cpp:1033`. If this, happens, setting
   `export _RSC_RSERVER_DATA_DIR_=$(mktemp -d)` before calling `rsc
   start` should work around the error.


## Version 0.13.3 [2023-04-17]

### New Features

 * When the RStudio Server fails to launch, troubleshooting
   information related to known problems is part of the error message.
 

## Version 0.13.2 [2023-03-30]

### New Features

 * `rsc start` now waits up to 10 seconds for the RStudio Server to
   respond on 'http://127.0.0.1:<port>'. If it fails to respond, a
   informative warning is generated. It then continues to assert that
   the server process is still running, before outputting the
   instructions on how to connect.  This strategy should avoid
   outputting instructions that doesn't work if the RStudio Server
   fails to launch for one reason or the other.
 

## Version 0.13.1 [2023-03-29]

### New Features

 * `rsc --version --full` now also reports on the location of the
   RStudio Server and R executables.


## Version 0.13.0 [2023-03-29]

### New Features

 * `rsc start` now reports on the RStudio Server and R versions.

### Miscellaneous

 * `rsc start` now makes sure that also R is a working state, before
   launching the RStudio Server instance. This is done by verify that
   `R --version`, `R --help`, and `R --vanilla -e 42` run without an
   error code.


## Version 0.12.0 [2023-02-20]

### Significant Changes

 * The instructions for SSH port forwarding now suggests to use the
   same port number on local host as used by the RStudio Server
   instance. Previously, the port was hard-coded to 8787, when using
   SSH port forwarding.  This simplifies the instructions, because
   only one port number is involved.  It also makes the instructions
   for connection directly on the machine and remotely use the same
   port, which removes one potential point of confusion.

### New Features

 * Add command-line option `--localport` for specifying the local port
   that binds to the port on the remote machine where the RStudio
   Server is running, if it runs remotely.  The special case
   `--localport=port` (new default) will use the same port as
   specified by `--port`.

 * `rsc start` now skips instructions for setting up SSH port
   forwarding when it cannot detect if running from an SSH connection.

### Miscellaneous

 * Cleaned up and clarified `rsc start` instructions.

### Bug Fixes

 * The connection URL given in the `rsc start --revtunnel=<spec>`
   instructions did not have a hostname or a port.
  

## Version 0.11.2 [2023-02-18]

### Miscellaneous

 * The error message produced by the internal `assert_no_rserver()`
   function when it detects a stray`rserver` process running suggested
   only `kill <PID>`.  Now it suggests `kill -SIGTERM <PID>`, and
   `kill -SIGKILL <PID>` as a last resort.

 * ROBUSTNESS: Declaring more local variables as integers.


## Version 0.11.1 [2022-10-12]

### Bug Fixes

 * `rsc status --full` would give an error `du: cannot access '
    .../.local/share/rstudio/sessions/active/*/suspended-session-data/':
    No such file or directory` if there were no suspended RStudio
    Server session.
 

## Version 0.11.0 [2022-10-12]

### New Features

 * Now `rsc config` reports also on the RStudio User State Storage
   folder.  To get a details summary on what is stored in this folder,
   see `rsc config --full`.

 * Now `rsc status --full` report also on the CPU usage, RAM usage,
   status, and start time for the rserver, rsession, and the rserver 
   monitor processes, if they are running.
 

## Version 0.10.0 [2022-09-29]

### Significant changes

 * Now `--port=port4me` (default) generates a different port than
   previously.  The reason is that a new algorithm, [port4me], is used
   to generate the user-specific, pseudo-random, but deterministic
   port.  Previously, a Python-based implementation was used.  The new
   behavior corresponds to `--port="$(port4me --tool=rsc)"`.

 * Dropped command-line option `--port-seed=<seed>`, since
   `--port=random` is deprecated and defaults to `--port=port4me`.

 * Python is no longer needed for this tool.
 
 * Removed prototype `freeport`. Use the [port4me] tool instead.

### Miscellaneous

 * ROBUSTNESS: Now declaring integer type for local variables,
   whenever possible.

### Deprecated and defunct

 * `--port=random` and `--port=uid` are deprecated and equal to
   `--port=port4me`.
 

## Version 0.9.1 [2022-06-27]

### Bug Fixes

 * If `rsc stop` could fail to terminate some processes,
   e.g. `rserver` or `rsession`.  Now it attempts multiple times
   before giving up with an informative warning.  It attempts four
   times with `SIGTERM` signals with three seconds in-between.  If
   those fail, it tries one last time with the stronger `SIGKILL`
   signal.


## Version 0.9.0 [2022-06-09]

### New features

 * When using `rsc start --auth=auth-via-env --random-password`, the
   password is now display at the very end, instead of at the
   beginning.

 * `rsc start` now highlights URLs and temporary passwords in output,
   if the terminal supports it.

 * `rsc status --full` will show information how to reconnect to an
   already running RStudio Server instance.

 * The error message produced by `rsc start` when an instance is
   already running now suggests calling `rsc status --full` for
   instructions on how to reconnect.

### Bug fixes

 * `rsc start` and `rsc status` could report on the incorrect hostname
   of the machine where the RStudio Server instance is running,
   e.g. when launched via an interactive Slurm job.


## Version 0.8.4 [2022-04-20]

### New features

 * The warning and error messages on stray 'rserver' processes will
   now include instructions on how to terminate such processes.


## Version 0.8.3 [2022-04-03]

### Significant changes

 * For security reasons, environment variable `RSC_PASSWORD` is never
   exported to any of the R sessions running via the RStudio Server.
   Likewise, it is never written to the config files or any temporary
   file.

### New features

 * Environment variable `RSC_PASSWORD=random` now corresponds to
   specifying command-line option `--random-password`.
   
 
## Version 0.8.2 [2022-03-13]
 
### New features
 
 * Now `rsc status` reports also on the optional SSH reverse tunnel.
 
 * The `rsc start` message now not only specifies for how long, but
   also until what time the user has to connect and log into to the
   RStudio Server before everything times out.
 
### Bug fixes
 
 * When using `rsc start --revtunnel=<spec>`, the startup message did
   not including messages about timeout limits.
 
 
## Version 0.8.1 [2022-03-07]
 
### New features
 
 * The `rsc startup` startup message now includes "WARNING: You now
   have 10 minutes to connect to the RStudio Server and start the R
   session before everything times out".
 
 * Increased the RStudio Server timeout to 10 minutes.
 
 * Now timeout warnings reports also on the time point when the
   timeout shutdown will take place.
 
### Bug fixes
 
 * The RStudio Server timeout did not apply if the user never logged.
 
 
## Version 0.8.0 [2022-03-07]
 
### Significant changes
 
 * The RStudio Server will automatically terminate 5 minutes after the
   most recent R session was terminated. An R session may be
   terminated either by the user (e.g. calling `quit()` in R), or from
   timing out because it has been idle for more than two hours.  In
   other words, the default behavior is to automatically shut down
   everything after the user having been idle for more than 125
   minutes.
 
 * The timeout limit of an R session is now two hours regardless of
   how the RStudio Server is running. Previously, this timeout limit
   would be overridden by the maximum runtime of the job scheduler,
   but in order to avoid jobs running idle for a long time, locking up
   slots of the scheduler, we choose to time out everything regardless
   of requested run time.
   
 
## Version 0.7.0 [2022-03-02]
 
### New features
 
 * Now `rsc --version --full` report on the version for `rsc`, RStudio
   Server, and R.
 
 * `rsc` now respected environment variable `NO_COLOR`. Set it to any
   non-empty value to disable colored output.
 
 * `rsc status` will now warn against stray `rserver` processes that
   are running despite no existing lock and PID files.
 
### Bug fixes
 
 * In rare cases there can be stray `rserver` processes running that
   where launched by `rsc start`. Investigation showed that the PID
   files for such processes do not exist, e.g. `rsc status` would
   report that nothing was running. Now `rsc start` checks for such
   stray processes before attempting to start another RStudio Server
   instance and gives an informative error message if detected.
   
 * In the rare case that `rsc start` found a free random port that
   immediately after was found to be occupied, it would output the an
   obscure `ERROR: Not an integer: ERROR: [INTERNAL]: Identified port
   is not free: 4321` message. Now it reports `ERROR: Identified a
   free port, which now appears to be occupied: 4321`.
 
 
## Version 0.6.1 [2022-02-20]
 
### Miscellaneous
 
 * `rsc start` would output "rsc: line 825: kill: (30801) - No such
   process" when terminated via `SIGINT` (e.g. Ctrl-C).
 
### Bug fixes
 
 * `rsc stop` did not stop the SSH reverse-tunnel connection, if
   called, which prevented the `rsc start --revtunnel=<host>:<port>`
   call from terminating.
 
 
## Version 0.6.0 [2022-02-13]
 
### Security fix
 
 * The `$HOME/.config/rsc/var/run/rstudio-server/` folder and its
   subfolder `rstudio-rsession` folder were writable by anyone on the
   system (777 in Unix terms). The `rserver` process sets these file
   permissions by design, because these folders are meant to be used
   by different users on the system. This would not have been a
   problem if the `$HOME/.config/rsc/` folder would be fully private
   to the user (700 in Unix terms), but due to a thinko, that folder
   was accessible and readable by anyone. Combined, this could lead to
   anyone on the system being able to write to the above folders. We
   now make sure `$HOME/.config/rsc/` is fully private. Also, since
   `rsc` is only used to launch a personal RStudio Server instance, we
   recursively set all of its files and folders private too (700).
 
### New features
 
 * Using `rsc status --no-ssh` will skip attempts to SSH into another
   machine to check if the rserver is running there.
 
 * Now `rsc reset --force` warns if critical rsc-related files exists,
   and which they are, otherwise the cleanup is silent.
 
### Prototype
 
 * Add `freeport`.
 
### Bug fixes
 
 * `rsc` failed if called via a symbolic link.
 
 
## Version 0.5.0 [2022-02-10]
 
### Significant changes
 
 * `--port=uid` is the new default.
 
### New features
 
 * Add option `--quiet` to silence the instructions.
 
 * Now `rsc start` outputs a message when it shuts down the RStudio
   Server.
 
 * Now `rsc start` shuts down nicely when it receives a `SIGCONT`,
   `SIGTERM`, `SIGUSR2`, or `SIGINT` (e.g. Ctrl-C) signal.
 
 * Add built-in 'auth-via-ssh' authentication tool that use SSH toward
   a hostname to validate the password,
   e.g. `--auth=auth-via-ssh:log2`.
 
 * Now `rsc start --auth=<spec>` gives an informative error message if
   the `<spec>` is incomplete, e.g. when the 'expect' tool is missing.
 
 * Add `--random-password`, which sets `RSC_PASSWORD` randomly and
   echoes it. This can be used in combination with
   `--auth=auth-via-env`.
 
### Alpha testing
 
 * Add `rsc start --revtunnel=<spec>`.
 
 
## Version 0.4.0 [2022-02-10]
 
### New features
 
 * Add support to specify an alternative authentication method for the
   RStudio Server login, e.g. `rsc start --auth=<file>`, where
   `<file>` can be the path to an executable, or one of the built-in
   ones, which are 'auth-via-su' (default) and 'auto-via-env'.
 
 * `rsc status --field=hostname` and `rsc status --field=port` report
   on the hostname and the port of the running RStudio Server.
 
 * `rsc status --force --field=...` skips any attempts to check and
   clean up stray files.
 
 * `rsc status` now reports also on the RStudio Server's listening
   port.
 
 * Now `rsc` tries extra hard to infer the hostname, which is done by
   first querying `$HOSTNAME` and `hostname` as a fallback. If neither
   works, then an informative error is produced.
 
 * Now `rsc reset --force` produces an informative warning.
 
 * Added `rsc wait`, which waits until `rsc start &` is fully running.
 
### Bug fixes
 
 * `rsc start` no longer uses `mktemp` in case that fails, which, by
   the way, is extremely rare and a problem with the system setup.
 
 
## Version 0.3.4 [2022-02-08]
 
### New features
 
 * Add option `--env-pattern=<regular expression>`.
 
### Deprecated and defunct
 
 * Remove option `--env` in favor of `--env-pattern`.
 
 
## Version 0.3.3 [2022-02-03]
 
### Bug fixes
 
 * Internal `check_pid()` could give incorrect results when checking a
   process PID on another machine.
 
 
## Version 0.3.2 [2022-02-03]
 
### Bug fixes
 
 * `rsc start` failed to remove stray lockfile, even when it was known
   that there were no 'rserver' and 'rsession' processes running.
 
 
## Version 0.3.1 [2022-02-03]
 
### New features
 
 * Now `rsc` can check process PIDs on another machine as well, which
   requires SSH access to that other machine.
 
 * Now `rsc` respects environment variable `XDG_CONFIG_HOME`. If not
   set, the default is `$HOME/.config`.
 
 
## Version 0.3.0 [2022-01-30]
 
### Significant changes
 
 * Add option `--env=<spec>`. If `--env=all`, then the R session, and
   any terminal opened in RStudio, inherits all environment variables
   that were exported in the shell where `rsc start` was called. If
   `--env=none`, then only environment variables predefined by the
   RStudio Server are set.
   
### Bug fixes
 
 * `rsc` would incorrectly remove the lock file when the RStudio
   Server was running on another machine on the same system.
 
 * `rsc status` reported that 'rserver' and 'rsession' were not
   running when called on another machine than where they are running.
 
 
## Version 0.2.4 [2022-01-29]
 
### New features
 
 * Add support for `--port-seed=<seed>`, which sets the random seed
   used when finding a free, random port (`--port=random`).
 
 * Add support for `--port=uid`, which is short for `--port-seed=$(id
   -u)` and `--port=random`. This makes the sequence of random ports
   tests deterministic and unique to the current user. This strategy
   increases the chance for a user to get the same port in subsequent
   calls.
 
 * Add support for `--dryrun`, which does everything but launching the
   RStudio Server. This is useful for troubleshooting and development.
 
 * Now `rsc` removes stray PID and lock files, if it can be concluded
   that they are stray files.
   
 
## Version 0.2.3 [2022-01-29]
 
### New features
 
 * `rsc start` now ignores a stray lock file if there is no other
   evidence that an RStudio Server instance is running.
 
 * `rsc start` now detect when RStudio Server fails to launch and
   gives an informative error message.
 
 * `rsc start` now asserts that the port is available before trying to
   launch the RStudio Server.
 
 
## Version 0.2.2 [2022-01-29]
 
### New features
 
 * `rsc start` instructions include information on `$USER`.
 
 * `rsc status` report on the lock file too.
 
 * `rsc status` now reports on "unknown" statuses if the RStudio
   Server is running on another machine.
 
### Bug fixes

 * `rsc start` failed to shut down nicely when receiving `SIGTERM`,
   resulting in R sessions and lock files being left behind.
 
 * `src stop` would fail on machines where environment `HOSTNAME` is
   not correct. Now relying on `hostname` instead.
 
 
## Version 0.2.1 [2022-01-26]
 
### New features
 
 * If `rsc start` fails because there's already an existing RStudio
   Server running, the error message now includes on what machine that
   instance is running.
 
### Bug fixes
 
 * Internal validation of `auth-via-su` could output messages to
   standard error. Those are now muffled.
 
 
## Version 0.2.0 [2022-01-26]
 
### New features
 
 * Now `rsc start` only gives instructions how to access the RStudio
   Server instance from a remote machine, when connected from one.
 
 * Now the `rsc start` instructions on how to connect from a remote
   machine infers the login hostname from the current connection by
   querying `who` and `host`.
 
 * When running the RStudio Server via an interactive job, then the R
   session timeout limit is inferred from maximum run-time as given by
   the job scheduler. If this cannot be inferred, the timeout limit
   defaults to 120 minutes.
 
### Bug fixes
 
 * `rsc stop` called from another machine on the same system would
   silently remove the internal lock file used to prevent more than
   one RStudio Server instance from running. Now an informative error
   message is produced informing on what machine the server is running
   and need to be stopped from.
 
 
## Version 0.1.2 [2022-01-25]
 
### New features
 
 * Now the `auth-via-su` script is distributed part of this software.
 
### Bug fixes
 
 * Environment variable `R_LIBS_USER` was ignore.
 
 
## Version 0.1.1 [2022-01-25]
 
### Significant changes
 
 * `rsc` no longer loads Linux environment modules. Instead, the user
   is responsible for making sure R and RStudio Server executables are
   on the `PATH`. This gives the user maximum flexibility in what R
   version to run. The `rsc` tool will produce informative error
   messages if these executables are not found.
 
### New features
 
 * Add `rsc config --full`.
 
 * Add `rsc log`.
 
 * Now `rsc start` will make sure to terminate the RStudio Server
   instance and any running R sessions when exiting.
   
 
## Version 0.1.0 [2022-01-22]
 
### New features
 
 * Add `freeport` to find a free TCP port.
 
 * Add `launch_rstudio_server`, which launches the RStudio Server on
   the current machine at a random port. The server and any running R
   session it launched will be terminated when `launch_rstudio_server`
   terminates, e.g. from Ctrl-C.


[port4me]: https://github.com/HenrikBengtsson/port4me
