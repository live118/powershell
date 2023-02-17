function Export-ADComputerInfoToCsv {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$CsvPath
    )

    # Import Active Directory module
    Import-Module ActiveDirectory

    # Get all computer objects and select the required properties
    $Computers = Get-ADComputer -Filter * -Properties OperatingSystemVersion, whenCreated | Select-Object Name, OperatingSystemVersion, @{n='Build';e={$_.OperatingSystemVersion -replace '^.*(\d{5,}).*$','$1'}}, whenCreated

    # Export the computer information to the specified CSV file path
    $Computers | Export-Csv -Path $CsvPath -NoTypeInformation
}
