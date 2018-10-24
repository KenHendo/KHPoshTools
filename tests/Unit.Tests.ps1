Param(
    [Parameter()]
    [String]$ScriptPath
)

If (-not $Scriptpath) {

    $ModuleName = 'KHPoshTools'
    
    If ((Get-module).name -contains $ModuleName) {
        Write-Host "$Modulename already found in runspace.  Unloading for a clean start"
        Remove-Module -Name $ModuleName -Force
    }
   
    $here = Split-Path -Parent $MyInvocation.MyCommand.Path 
    $ModulePath = (Split-Path -parent $here) + "\$ModuleName"
    $sut = $modulepath + "\$ModuleName.psm1"
    #. $sut
    import-module $ModulePath -Force 
}

Else {

    . $ScriptPath
}


Describe "KHPoshTools : UNIT TESTS" {

    $CompNameTestCases = @(

        @{ComputerName = 'TestMachine1'; ExpectedCount = 1; TestName = 'Single Computer'}
        @{ComputerName = @('TestMachine1', 'TestMachine2', 'TestMachine3'); ExpectedCount = 3; TestName = 'Multiple Computers'}
    )

    Mock New-CimSession -ModuleName 'KHPoshTools' {
        New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession'
    }

    #Mock Get-CimInstance {} -ParameterFilter {! $PSBoundParameters.ContainsKey('ComputerName')}
    Mock Get-CimInstance -ModuleName 'KHPoshTools' { 1 }
    
    Write-Verbose 'Testing that the function accepts input correctly'
    Context Input {
        
        It 'Returns the right number of objects based on ComputerName(s) entered: <Testname>' -TestCases $CompNameTestCases {
            Param(
                $ComputerName,
                $ExpectedCount
            )
            $result = Get-KHComputer -ComputerName $ComputerName
            $result.count | should BeExactly $ExpectedCount  
        } 

        It 'Does not Accept a Null value for computername' {
            { Get-KHComputer -ComputerName $null} | should throw
        }

        It 'Accepts input by Pipeline: <Testname>' -TestCases $CompNameTestCases {
            Param (
                $Computername,
                $ExpectedCount
            )
            $result = $ComputerName | Get-KHComputer
            $result.count | should BeExactly $ExpectedCount  
        }
        
        It "Accepts a ComputerName via positional parameter" {
            {Get-KHComputer 'TestComputer'} | should be $true
        }
    }#context Input

    Write-Verbose 'Testing that the function executes its internal code to produce the desired result'
    Context Execution {
        
        Mock New-CimSession -ModuleName 'KHPoshTools' {
            New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession'
        }
        It 'Creates a single CIMSesssion for each computername supplied: <Testname>' -TestCases $CompNameTestCases {
            Param (
                $Computername,
                $ExpectedCount
            )
            Get-KHComputer -ComputerName $Computername
            Assert-MockCalled -CommandName 'New-CimSession' -Times $ExpectedCount
        }

        It 'Should remove the CIMSession when done' -skip {}

    }#Context Execution

    Write-Verbose 'Testing that the function produces any required output correctly'
    Context Output {

    }# Context Output
}
