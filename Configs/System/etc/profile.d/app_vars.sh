#!/usr/bin/env bash

# XDG Apps
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export HISTFILE="${XDG_STATE_HOME}/bash/history"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export KDEHOME="${XDG_CONFIG_HOME}/kde"
export NUGET_PACKAGES="${XDG_CACHE_HOME}/NuGetPackages"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export SQLITE_HISTORY="${XDG_CACHE_HOME}/sqlite_history"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java"   # Some applications do not respect this.

# Terminal things
export GPG_TTY=$(tty)   # Enable commit signing in the shell
export EDITOR=nano      # Set nano as the default text editor for sudoedit

# Docker/Podman bridge
DOCKER_HOST="unix://$(podman info --format '{{.Host.RemoteSocket.Path}}')"
# Docker Rootless
#DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
export DOCKER_HOST
