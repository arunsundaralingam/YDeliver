task NugetPublish {

    $taskConfig = Get-InstallTaskConfiguration
    $artifactsDir = Get-Conventions artifactsDir

    $taskConfig.packages | %{
        $packagePaths = Resolve-Path "$artifactsDir\$_"
    }
    if(Test-Path $taskConfig.source){
        $packagePaths | %{
            Write-ColouredOutput "Publishing package $_ to $($taskConfig.source)" yellow
            Copy-Item $_ -destination $taskConfig.source
        }
    } else {
        $packagePaths | %{ 
            Write-ColouredOutput "Publishing package $_ to $($taskConfig.source)" yellow
            exec { nuget push $_ -source "$($taskConfig.source)" -noninteractive } "Nuget push failed."
        }
    }
}