Param(
    [Parameter()]
    [String]$ScriptPath
)

If (-not $Scriptpath) {

    $ModuleName = 'KHPoshTools'
    $here = Split-Path -Parent $MyInvocation.MyCommand.Path 
    $ModulePath = (Split-Path -parent $here) + "\$ModuleName"
    $sut = $modulepath + "\$ModuleName.psm1"
    . $sut
}

Else {

    . $ScriptPath
}


Describe "KHPoshTools : UNIT TESTS" {
    
    Write-Verbose 'Testing that the function accepts input correctly'
    Context Input {

        Mock New-CimSession {
            $MockSession = New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession'
            Write-Output $MockSession
        }
        #Mock Get-CimInstance {} -ParameterFilter {! $PSBoundParameters.ContainsKey('ComputerName')}
        Mock Get-CimInstance { 1 }

        $CompNameTestCases = @(

            @{ComputerName = 'TestMachine1'; ExpectedCount = 1; TestName = 'Single Computer'}
            @{ComputerName = @('TestMachine1', 'TestMachine2', 'TestMachine3'); ExpectedCount = 3; TestName = 'Multiple Computers'}
        )

        It 'Creates a single CIMSesssion for each computername supplied' {

        }
        
        It 'Returns the right number of objects based on ComputerName(s) entered: <Testname>' -TestCases $CompNameTestCases {
            Param(
                $ComputerName,
                $ExpectedCount
            )
            Mock New-CimSession {New-MockObject -Type 'Microsoft.Management.Infrastructure.CimSession' }
            $result = Get-KHComputer -ComputerName $ComputerName
            $result.count | should BeExactly $ExpectedCount  
        } 

        It 'Does not Accept an empty or null value for computername' -skip {

        }

        It "Accepts input by Pipeline" -skip {

        }
        
        It "Accepts a ComputerName via positional parameter" -skip {

        }
    }#context Input

    Write-Verbose 'Testing that the function executes its internal code to produce the desired result'
    Context Execution {

    }#Context Execution

    Write-Verbose 'Testing that the function produces any required output correctly'
    Context Output {

    }# Context Output
}
