# Multiple Postgres Versions Locally with ASDF

These are just a few scripts and a workflow that I use locally to manage multiple versions of Postgres running at the same time. Use them this way or as a starter for your own workflow.

## Requirements:
- asdf - https://github.com/asdf-vm/asdf
- asdf-postgres - https://github.com/smashedtoatoms/asdf-postgres
- A shell. I like ZSH.

## Usage

Suppose you have two versions of postgres installed locally via ASDF: 10.5 and 9.6. Lets say "App A" uses 10.5 and "App B" uses 9.6. You probably have a `.tool-versions` file in the root of each specifying the appropriate postgres version.

The point of these scripts is to start (on a unique port), stop, and report on which versions are running. Here is my end workflow assuming the aliases further down the page.

#### `pgstatus` - View status of all pg versions

In the "App A" directory...

```
> pgstatus

Postgres Version Status (`pgstatusv` for verbose)
-----------------------
10.5 (current): Not running. Start with `pgstart[2,3]`.
9.6.3: Not running.
```

#### `pgstatusv` - View verbose status of all pg versions

Verbose status will display the contents of the `postmaster.pid`. We can see that 10.5 is running on port 5432.

```
> pgstatusv

Postgres Version Status
-----------------------
10.5 (current): Running.
Contents of /Users/baldwindavid/.asdf/installs/postgres/10.5/data/postmaster.pid
7375
/Users/baldwindavid/.asdf/installs/postgres/10.5/data
1540566911
5432
/tmp
localhost
  5432001    196608
ready

9.6.3: Not running.
```

#### `pgstart` - Start a version

Start 10.5

```
> pgstart

Postgres Version Status (`pgstatusv` for verbose)
-----------------------
10.5 (current): Running.
9.6.3: Not running.
```

#### `pgstart2` or `pgstart3` - Run a version on a different port

Now in the "App B" directory. We know that 9.6 is unstarted. We are going to want to run it at the same time, but will need it to be on a different port. We can run `pgstart2` to automatically run on port 5433.

```
> pgstart2

Postgres Version Status
-----------------------
10.5: Running.
Contents of /Users/baldwindavid/.asdf/installs/postgres/10.5/data/postmaster.pid
7375
/Users/baldwindavid/.asdf/installs/postgres/10.5/data
1540566911
5432
/tmp
localhost
  5432001    196608
ready

9.6.3 (current): Running.
Contents of /Users/baldwindavid/.asdf/installs/postgres/9.6.3/data/postmaster.pid
9290
/Users/baldwindavid/.asdf/installs/postgres/9.6.3/data
1540567242
5433
/tmp
localhost
  5433001    131073
```

`pgstart2` and `pgstart3` will always display the "verbose" status so you can inspect the ports.

#### `pgstop` - Stop a version

In the 9.6 directory...

```
> pgstop

Postgres Version Status (`pgstatusv` for verbose)
-----------------------
10.5: Running.
9.6.3 (current): Not running. Start with `pgstart[2,3]`.
```

#### `pgstopall` - Stop all versions

It doesn't matter where this is run.

```
> pgstopall

Stopping All Postgres Versions
------------------------------
10.5: Stopping.
9.6.3 (current): Not running. Nothing to do.


Postgres Version Status (`pgstatusv` for verbose)
-----------------------
10.5: Not running.
9.6.3 (current): Not running. Start with `pgstart[2,3]`.
```

## Aliases

In order for this to work, you'll need to setup some aliases pointing to the included Ruby scripts. Here are the aliases I added to `.zshrc`. Change the path to the Ruby scripts to wherever they reside on your system.

```
# Postgres Version Management
alias pgstart="echo 'Attempting to start on port 5432'; pg_ctl start; pgstatus"
alias pgstart2="echo 'Attempting to start on port 5433'; PGPORT=5433 pg_ctl start; pgstatusv"
alias pgstart3="echo 'Attempting to start on port 5434'; PGPORT=5434 pg_ctl start; pgstatusv"
alias pgstop="pg_ctl stop; pgstatus"
alias pgstopall="ruby ~/CHANGE_ME/dev_postgres_scripts/postgres_stop_all_versions.rb; pgstatus"
alias pgstatus="ruby ~/CHANGE_ME/dev_postgres_scripts/postgres_status.rb"
alias pgstatusv="ruby ~/CHANGE_ME/dev_postgres_scripts/postgres_status_verbose.rb"
```

Certainly feel free to rename any of these aliases and bend them to your will. There are three `pgstart` aliases here, but add as many as you need.

## Ruby Scripts

The included scripts are very simple. Feel free to change them to whatever you need.

