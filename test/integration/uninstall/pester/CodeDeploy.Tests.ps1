Describe "codedeployagent service" {
    It "is uninstalled" {
        (Get-Service codedeployagent).length | Should Be 0
    }
}
