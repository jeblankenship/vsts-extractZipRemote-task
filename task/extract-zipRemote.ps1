[CmdletBinding()]
param(
    [string] $server,
    [string] $zipFile,
    [string] $destination
)

Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

Write-Verbose "Entering script $($MyInvocation.MyCommand.Name)"
Write-Verbose "Parameter Values"
$PSBoundParameters.Keys | % { Write-HOST "  ${_} = $($PSBoundParameters[$_])" }

$command = {
    param(
        [string]$zipFile,
        [string]$destination
    )

    Add-Type -assembly “system.io.compression.filesystem”

    if(Test-Path $destination){
        #delete existing content
        Write-Verbose "Removing existing content from $destination"
        Remove-Item $destination\* -Recurse -Force
    }
    Write-Verbose "Unziping file $zipFile to $destination"
    [io.compression.zipfile]::ExtractToDirectory($zipFile, $destination)
    Write-Verbose "Zip file extraction complete."
}


Invoke-Command -ComputerName $server $command -ArgumentList $zipFile,$destination