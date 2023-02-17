function Get-ADUnusedComputer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [int]$DaysInactive
    )

    # Calculate the inactive date
    $InactiveDate = (Get-Date).AddDays(-$DaysInactive)

    # Import the Active Directory module
    Import-Module ActiveDirectory

    # Query Active Directory for computer objects that have not been used since the inactive date
    Get-ADComputer -Filter {LastLogon -lt $InactiveDate} -Properties LastLogon, OperatingSystem, OperatingSystemVersion, whenCreated | Select-Object Name, OperatingSystem, OperatingSystemVersion, whenCreated, @{Name='LastLogonDate'; Expression={[DateTime]::FromFileTime($_.LastLogon)}} | Sort-Object whenCreated | Format-Table
}
