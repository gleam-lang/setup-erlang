#! /usr/bin/pwsh
param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]$otpVersion,

    [Parameter(Mandatory=$false, Position=1)]
    [string]$rebar3Version = ''
)

# Terminate on error
$ErrorActionPreference = "Stop"

# Ensure we have PSScriptRoot
if (!(Test-Path variable:global:PSScriptRoot)) {
    # Support powershell 2.0
    $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}

# Temporary folder
$dir = "$PSScriptRoot\$(([System.Guid]::NewGuid()).Guid)"
mkdir $dir | Out-Null
Push-Location $dir

# Download erlang
"Downloading Erlang/OTP $otpVersion package"
Invoke-WebRequest -Uri "https://packages.erlang-solutions.com/erlang/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_$otpVersion~windows_amd64.exe" -OutFile "esl-erlang_$otpVersion~windows_amd64.exe"

# Install erlang (runs in background)
"Installing Erlang/OTP $otpVersion"
& ".\esl-erlang_$otpVersion.0~windows_amd64.exe" '/S'

# Wait for it..
while (@(Get-Process | Where-Object { $_.name -match 'esl-erlang' }).length -gt 0) {
    Start-Sleep -Milliseconds 100
}

# Download rebar3
if( $rebar3Version -eq 'true' )
{
    switch  -Wildcard ( $otpVersion )
    {
        '24*' { $rebar3Version='3.16.1' }
        '23*' { $rebar3Version='3.16.1' }
        '22*' { $rebar3Version='3.16.1' }
        '21*' { $rebar3Version='3.15.2' }
        '20*' { $rebar3Version='3.15.2' }
        '19*' { $rebar3Version='3.15.2' }
        '18*' { $rebar3Version='3.11.1' }
        '17*' { $rebar3Version='3.10.0' }
        default
        {
            Write-Error -Message 'Installing Rebar3 for OTP version $otpVersion not supported'
            $rebar3Version=''
        }
    }
}

if ( $rebar3Version -ne '' )
{
    "Downloading Rebar3 $rebar3Version"
    Invoke-WebRequest -Uri "https://github.com/erlang/rebar3/releases/download/$rebar3Version/rebar3" -OutFile "rebar3.exe"

    # Wait for it..
    while (@(Get-Process | Where-Object { $_.name -match 'rebar3' }).length -gt 0) {
        Start-Sleep -Milliseconds 100
    }

    New-Item -Path $env:ProgramFiles\Rebar3 -ItemType Directory
    Move-Item rebar3.exe $env:ProgramFiles\Rebar3
    $rebar3root = (Get-ChildItem -path $env:ProgramFiles\Rebar3 -directory).FullName

    "Rebar3 $rebar3Version installed in $rebar3root"

    # Set output of step to rebar3 path
    "::set-output name=rebar3path::$rebar3root"
}

Pop-Location

# Cleanup (but don't fail on error)
Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue

# Locate installation path
$erlroot = (Get-ChildItem -path $env:ProgramFiles -filter erl* -directory).FullName
"Erlang/OTP $otpVersion installed in $erlroot"

# Set output of step to erlang path
"::set-output name=erlpath::$erlroot"
