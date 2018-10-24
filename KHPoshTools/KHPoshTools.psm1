Function Get-KHComputer {

    [CmdletBinding()]

    Param(

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [string[]]$ComputerName
    )

    Begin {}
    
    Process {
        Foreach ($Computer in $ComputerName) {
        
            #Create CIMSession for the various queries
            $Param = @{
                ComputerName = $Computer
            }

            $Session = New-CimSession @Param

            #Query the computer
            $CompSysParam = @{
                CimSession   = $Session
                Classname = 'Win32_ComputerSystem'
            }

            $CompSysInfo = Get-CimInstance @CompSysParam
            Write-Output $CompSysInfo
        }
    }

    End {}
}#Function Get-KHComputer

Function Set-KHComputer {

}