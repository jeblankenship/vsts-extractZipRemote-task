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
        $count = 0;
        $retry = $true;
        Write-Host "Removing existing content from $destination"
        do {
            Try
            {
                Remove-Item $destination\* -Recurse -Force
                $retry=$false;
            }
            Catch
            {
              $count += 1;
              if($count -gt 3){
                Throw $_.Exception
              }
              Write-Host "Content removal failed. Waiting to try again..."
              Start-Sleep -Seconds 5
              Write-Host "Attempting to remove content again..."
            }
        } while ($retry)
    }
    $count = 0;
    $retry = $true;
    Write-Host "Unziping file $zipFile to $destination"
    do {
        Try
        {
            [io.compression.zipfile]::ExtractToDirectory($zipFile, $destination)
            Write-Host "Zip file extraction complete."
            $retry=$false;
        }
        Catch
        {
          $count += 1;
          if($count -gt 3){
            Throw $_.Exception
          }
          Write-Host "Extraction failed. Waiting to try again..."
          Start-Sleep -Seconds 5
          Write-Host "Attempting to unzip file again..."
        }
    } while ($retry)
}


Invoke-Command -ComputerName $server $command -ArgumentList $zipFile,$destination