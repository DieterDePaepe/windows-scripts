# Conversion of warp.bat to work with modern PowerShell environments. Written by thatmaxplayle (https://github.com/thatmaxplayle)
# Based on original script by DieterDePaepe (https://github.com/DieterDePaepe)
# Be sure to commit any improvements made to the upstream repository!
param (
    [string]$Bookmark,
    [switch]$Create,
    [switch]$Remove,
    [switch]$List,
    [switch]$Help
)

# Define the folder where all links will end up
$WARP_REPO = "$HOME\.warp"

function Show-Help {
    Write-Host @"
Create or navigate to folder bookmarks.

  warp -Help                            Display this help page
  warp -Bookmark [bookmark]             Navigate to an existing bookmark
  warp -Remove -Bookmark [bookmark]     Remove an existing bookmark
  warp -Create -Bookmark [bookmark]     Create a new bookmark (uses the current working directory)
  warp -List                            List existing bookmarks
"@
}

function Create-Bookmark {
    if (-not $Bookmark) {
        Write-Host "Error: You need to provide a name for this bookmark!"
        exit
    }

    if (-not (Test-Path $WARP_REPO)) {
        New-Item -ItemType Directory -Path $WARP_REPO | Out-Null
    }

    $PWD.Path | Out-File -FilePath "$WARP_REPO\$Bookmark" -Encoding utf8 -NoNewline
    Write-Host "Created bookmark: $Bookmark"
}

function List-Bookmarks {
    Get-ChildItem $WARP_REPO -Name
}

function Remove-Bookmark {
    if (-not $Bookmark) {
        Write-Host "Error: You need to provide the name of the bookmark you'd like to delete."
        exit
    }

    if (-not (Test-Path "$WARP_REPO\$Bookmark")) {
        Write-Host "Error: No such bookmark with name $Bookmark"
        exit
    }

    Remove-Item "$WARP_REPO\$Bookmark"
}

function Navigate-Bookmark {
    if ($Bookmark) {
        $WARP_DIR = Get-Content "$WARP_REPO\$Bookmark" -Raw
        $WARP_DIR = $WARP_DIR.Trim()  # Remove any extraneous whitespace
        if (Test-Path $WARP_DIR) {
            Set-Location $WARP_DIR
        }
        else {
            Write-Host "Error: The path '$WARP_DIR' does not exist."
        }
    }
    else {
        Write-Host "Error: You need to provide the name of the bookmark you'd like to navigate to."
    }
}

if ($Help) {
    Show-Help
}
elseif ($Create) {
    Create-Bookmark
}
elseif ($Remove) {
    Remove-Bookmark
}
elseif ($List) {
    List-Bookmarks
}
elseif ($Bookmark) {
    Navigate-Bookmark
}
else {
    Show-Help
}
