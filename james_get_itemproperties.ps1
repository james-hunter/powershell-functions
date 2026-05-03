#cf
#https://github.com/mossrich/PowershellRecipes/blob/master/Get-ShellApplicationPropertiesAndVerbs.ps1


Function James-Get-ItemProperties{

    #Gets item properties from Shell.Application COM Object - those that will be visible in Windows Explorer 
	param(
		[string][Parameter(Mandatory = $true, Position=0)]$item
	)
    
    if(test-path $item){

        $itemobject = Get-Item $item
        if($itemobject.Attributes -ne "Directory"){
            $itempath = $itemobject | select -ExpandProperty directoryname
			$itemname = $itemobject | select -ExpandProperty name
			
			$ns =  (New-Object -ComObject Shell.Application).NameSpace($itempath); 
			
			#the list of properties this folder supports in the shell (usually a superset of the properties shown in UI) 
			$PropertyList = $(
			#assumes that all properties are contiguous and start with 0 
				$i=0
				do { 
					[pscustomobject]@{
						index=$i
						name=$ns.GetDetailsOf($ns.Items,$i++)
					} 
				} while ($ns.GetDetailsOf($ns.Items,$i)) 
			)
			
			$itemn = $ns.ParseName($itemname)
			#iterate through all properties in the namespace, and get values for the item
			$PropertyList | ? {$PropertyName -eq $null -or $_.name -eq $PropertyName}| %{ 
				[pscustomobject] @{
					Path = $itempath
					Name = $itemn.Name
					PropertyIndex = $_.index
					PropertyName = $_.name
					PropertyValue = $ns.GetDetailsOf($itemn ,$_.index)
				}
			}
		}
		else{
			write-host "Item '$($item)' is a directory. Use native 'get-item' command."
			
		}
    }
            

    else{
        write-host "Item '$($item)' not found"
    }
}

