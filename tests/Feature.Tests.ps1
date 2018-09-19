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


Describe "KHPoshTools : FEATURE TESTS" {
    It "does something useful" {
        $true | Should -Be $true
    }
}
