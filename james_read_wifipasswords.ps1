Function James-Read-WifiPasswords{
        
    $line_regex1 = [regex]"(?<=^.+:\s).+(?=(|\s))" 
    $line_regex2 = [regex]"(?<=^\s+)\w.+\w(?=\s+:)" 
    $line_regex3 = [regex]"(?<=^.+:\s).+" 
    [string]$wifi_profiles_data = (netsh.exe wlan show profile | out-string)
    $wifi_profiles = @(foreach($line in ($wifi_profiles_data -split("`r|`n"))){
        $line_regex1.Matches($line)
    })
    $profile_contents = @(foreach($wifi_profile in $wifi_profiles){
        [string]$profile_content = (netsh.exe wlan show profile name=$wifi_profile key=clear | out-string)          
        $profile1 = New-Object -TypeName psobject 
        $header_names = @()
        foreach($line in ($profile_content -split("`r|`n"))){
            if($null -ne $line_regex2.Matches($line).value){
                $i = 0
                do{
                    $property_name = "$($line_regex2.Matches($line).value)$("_" * $i)"
                    $i++
                }until($header_names -notcontains $property_name)
                $header_names += $property_name
                $profile1 | Add-Member -MemberType NoteProperty -Name $property_name -Value $line_regex3.Matches($line).value
            }
        }
        $profile1 
    })
    return $profile_contents
}
