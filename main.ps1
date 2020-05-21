#! /usr/bin/pwsh
param (
    [Parameter(Mandatory=$true, Position=0)]
    [int]$version
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
Push-Location $dir

# Download erlang
"Downloading Erlang/OTP $version package"
Invoke-WebRequest -Uri "https://packages.erlang-solutions.com/erlang/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_$version.0~windows_amd64.exe" -OutFile "esl-erlang_$version.0~windows_amd64.exe"

# Install erlang (runs in background)
"Installing Erlang/OTP $version"
& ".\esl-erlang_$version.0~windows_amd64.exe" '/S'

# Wait for it..
while (@(Get-Process | Where-Object { $_.name -match 'esl-erlang' }).length -gt 0) {
    Start-Sleep -Milliseconds 100
}

Pop-Location

# Cleanup (but don't fail on error)
Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue

# Locate installation path
$erlroot = (Get-ChildItem -path $env:ProgramFiles -filter erl* -directory).FullName
"Erlang/OTP $version installed in $erlroot"

# Set output of step to erlang path
"::set-output name=erlpath::$erlroot"
