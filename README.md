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