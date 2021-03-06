﻿# fail on errors and include uplift helpers
$ErrorActionPreference = "Stop"

Import-Module Uplift.Core

Write-UpliftMessage "Running Configure_AppSOE config..."
Write-UpliftEnv

Configuration Configure_AppSOE {

    Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.17.0.0
    Import-DscResource -ModuleName xNetworking -ModuleVersion 5.5.0.0

    Node localhost
    {
        LocalConfigurationManager
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $false
            RefreshMode = "Push"
        }

        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }

        WindowsFeature ADDSRSAT
        {
            Ensure = "Present"
            Name = "RSAT-ADDS-Tools"
        }

        WindowsFeature RSAT
        {
            Ensure = "Present"
            Name = "RSAT"
        }
    }
}

$config = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PSDscAllowPlainTextPassword = $true
            RetryCount = 10
            RetryIntervalSec = 30
        }
    )
}

$configuration = Get-Command Configure_AppSOE
Start-UpliftDSCConfiguration $configuration $config

exit 0