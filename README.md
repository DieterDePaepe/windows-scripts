# Windows Scripts
A collection of useful scripts for windows.

Install by checking out the code and adding the scripts to your `PATH` environment.

## Warp
A folder bookmarker for use in the terminal.

    c:\Temp>warp /create temp     # Create a new bookmark
    Created bookmark "temp"
    c:\Temp>cd c:\Users\Public    # Go somewhere else
    c:\Users\Public>warp temp     # Go to the stored bookmark
    c:\Temp>

Every warp uses a `pushd` command, so you can trace back your steps using `popd`.

    c:\Users\Public>warp temp
    c:\Temp>popd
    c:\Users\Public>

Open a folder of a bookmark in explorer using `warp /window <bookmark>`.

List all available options using `warp /?`.

## RefreshEnv
Refresh the environment variables in the terminal. Handy when you updated an environment variable (such as `PATH`), but don't want to restart the terminal.

    c:\>refreshEnv

## AddToPath
Adds a folder to the `PATH` of the current terminal. This change is not persisted in the `PATH` environment variable.

    # The following examples all add c:\Temp to the local PATH:
    c:\Temp>addToPath          # Add current folder
    c:\>addToPath Temp         # Add a relative path
    c:\>addToPath c:\Temp      # Add an absolute path  