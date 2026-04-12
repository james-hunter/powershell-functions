
Function James-Copy-Item{

    param(
        [string][Parameter(Mandatory = $true, Position=0)][ValidateScript({Test-Path $_ -PathType Any})]$source,
        [string][Parameter(Mandatory = $true, Position=1)][ValidateScript({
            Test-Path $_ -PathType Container
        })]$destination,
        [switch][Parameter(Mandatory = $false, Position=2)]$whatif,
        [switch][Parameter(Mandatory = $false, Position=3)]$clobber,
        [string][Parameter(Mandatory = $false, Position=4)][ValidateScript({
            if(@($null, "") -contains $_ ){
                return $true
            }
            else{
                Test-Path $_ -PathType Container
            }
        })]$logpath
    )



    $source1 = get-item $source
    try {
        $destItem = Get-Item -Path $destination -ErrorAction Stop
        $destination1 = $destItem.FullName.TrimEnd('\')
    }
    catch {
        Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tFailed to resolve destination: $_" -ForegroundColor Yellow
        return
    }    

    if($source1.GetType().fullname  -ne "System.IO.DirectoryInfo" ){
        if($clobber){
            try{
                Join-Path -Path $destination1  -ChildPath $source1.name -Resolve -ErrorAction stop
                Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tSource file exists in destination folder. Will be replaced with a copy of the source" -ForegroundColor Cyan
            }
            catch{
                Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tSource file does not exist in destination folder. Clobber null." -ForegroundColor Yellow
            }
        }
        else{
            try{
                Join-Path -Path $destination1  -ChildPath $source1.name -Resolve -ErrorAction Stop
                Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tSource file exists in destination folder. Operation cancelled. Run command again with clobber option to copy." -ForegroundColor Yellow
                return
            }
            catch{
                Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tSource file does not exist in destination folder." -ForegroundColor Blue
            }
        }

        $arguments = "/W:2 /R:2 /Z `"$($source1.directory.fullname)`" `"$($destination1)`" `"$($source1.name)`""
    }
    else{
        $source2 = $source1.fullname.TrimEnd('\')
        if($clobber){
            $arguments = "/MIR /W:2 /R:2 /MT:64 /Z `"$($source2)`" `"$($destination1)`""
        }
        else{
            $arguments = "/E /W:2 /R:2 /MT:64 /Z `"$($source2)`" `"$($destination1)`""
        }
    }

    
    if($whatif){
        $arguments = "/L " + $arguments
    }

    if($logpath){
        $logfile1 = join-path -Path $logpath -ChildPath "$(get-date -Format "yyyyMMdd_HHmmssfff")_robocopy_log.txt"
        $arguments = "/UNILOG+:$($logfile1) " + $arguments
    }
    
    $program = "robocopy.exe"
    $process = Start-Process -FilePath $program -ArgumentList $arguments -NoNewWindow -Wait -PassThru
    $exitcode = $process.ExitCode

    switch($exitcode){
        0 {
            $meaning = "Nothing to do - Everything already matches."
            break
        }
        1{
            $meaning = "Files copied successfully."
            break
        }
        2{
            $meaning = "EXTRA files found."
            break
        }
        3{
            $meaning = "Files copied and EXTRA files found."
            break
        }
        8{
            $meaning = "Retry limit exceeded. A file was locked, in use, or inaccessible."
            break
        }
        16{
            $meaning = "Error: Possible reasons: invalid paths; permissions; network disconnect; syntax errors; trailing slash issues."
            break
        }
        default{
            $meaning = "unknown"
            break
        }
    }


    if($logpath){
        write-host (get-content -Path $logfile1 | out-string) -ForegroundColor Cyan
    }
    if($exitcode -ge 8){
        Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tOutput contains failures" -ForegroundColor Red
    }
    else{
        Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tOutput successful" -ForegroundColor Green
    }
    Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tSource:        $($source)"
    Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tDestination:   $($destination)"
    Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tWhatif status: $($whatif)"
    Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tExit code:     $($exitcode)"
    Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tMeaning:       $($meaning)"
    

    
}
