Describe "codedeployagent service" {
    It "is installed" {
        (Get-Service codedeployagent).length | Should Be 1
    }

    It "is started" {
        (Get-Service codedeployagent).status | Should Be "Stopped"
    }

    It "is enabled" {
        (Get-Service codedeployagent).StartType | Should Be "Manual"
    }
}
