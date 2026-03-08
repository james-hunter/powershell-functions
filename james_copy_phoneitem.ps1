
Function James-Copy-PhoneItem{

    param(
        [object][Parameter(Mandatory = $false, Position=0)]$path
    )

    $shell = New-Object -ComObject Shell.Application    
    $thiscomputer = $shell.Namespace(17) #17 = this computer
    $i = 0
    do{
        try{
            $phone = $thiscomputer.Items() | where-object{$_.type -eq "Mobile Phone"}
        }
        catch{
            $phone = $null
        }
        Start-Sleep -Milliseconds 500
        $i++
    }until($phone -or $i -gt 10)
    
    if($i -gt 10){
        return 1;
    }
    elseif($phone){
       
        $j = 0
        do{
            try{
                $downloads = $phone.GetFolder().ParseName("Internal Storage").GetFolder().ParseName("Download").GetFolder()
            }
            catch{
                $downloads = $null
            }
            Start-Sleep -Milliseconds 500
            $j++
        }until($downloads -or $j -gt 10)
        
        if($j -gt 10){
            return 3;
        }
        elseif($downloads){
            $path = ($path) -replace('`(?=[\[\]])',"")

            if(test-path -LiteralPath $path){
                # Copy the file
                try{
                    $downloads.CopyHere($path)
                    return 0
                }
                catch{
                    return 4
                }
            }
            else{
                return 5
            }
        }
    }
    else{
        return 2
    }

}
