

Function James-Get-ArrayItem{

	param(
		[collections.arraylist][Parameter(Mandatory = $true, Position=0)]$array,
		[int][Parameter(Mandatory = $false, Position=1)][ValidateSet(1,2,3)]$displaymode = 2,
		[string][Parameter(Mandatory = $false, Position=2)]$property,
		[bool][Parameter(Mandatory = $false, Position=3)]$boxmode = $true,
		[bool][Parameter(Mandatory = $false, Position=4)]$index = $true,
		[bool][Parameter(Mandatory = $false, Position=4)]$single,
		[int][Parameter(Mandatory = $false, Position=5)]$columns
	)

	#not compatible with ise due to the missing .net/console commands in ise
	if($psise){
		write-host "$(get-date -format "yyyy/MM/dd HH:mm")`tThis get array item command is not compatibe with powershell ISE"
		return $array
	}
	
	#write function
	Function James-Write-ArrayItem{
	
		param(
		[Parameter(Mandatory = $true, Position=0)][array]$array,
		[Parameter(Mandatory = $false, Position=1)][string]$property,
		[Parameter(Mandatory = $false, Position=2)][int]$columns,
		[int][Parameter(Mandatory = $false, Position=3)][ValidateSet(1,2,3)]$displaymode = 2,
		[bool][Parameter(Mandatory = $false, Position=4)]$boxmode,
		[bool][Parameter(Mandatory = $false, Position=5)]$index
		)
	
		Function James-Write-boxMode{
		
			param(
				[Parameter(Mandatory = $true, Position=0)][array]$array,
				[int][Parameter(Mandatory = $false, Position=1)][ValidateSet(1,2,3)]$displaymode = 2
			)
	
			$middleleft =   [char]9500 # ├
			$middleright =  [char]9508 # ┤
			$middletop=     [char]9516 # ┬
			$middlebottom = [char]9524 # ┴
			$cross =        [char]9532 # ┼
			$horizontal =   [char]9472 # ─
			$vertical =     [char]9474 # │
			$lefttop =      [char]9484 # ┌
			$righttop =     [char]9488 # ┐
			$leftbottom =   [char]9492 # └
			$rightbottom =  [char]9496 # ┘
		
			$arraystring = $array | format-table * -AutoSize | out-string
			$lines1 = $arraystring -split("`r|`n") | where-object {$_ -match "^[ |\-]+$"}
			$columnstarts1 = @([regex]::matches($lines1,"(^-|(?<=\s)-)"))
			$array2 = @($arraystring -split("`r|`n")) | where-object{
				@($arraystring -split("`r|`n")).indexof($_) -gt  @($arraystring -split("`r|`n")).indexof($lines1) 
			} 
			if(@(3) -contains $displaymode){
			#in the show/write function, mode 1 and 2 are one property over many columns
			#in mode 3 you will get unpredictable headers so have to cut it back here.
			$array2 = @(@($arraystring -split("`r|`n") | where-object {$_ -match  "[A-Z]"})[0]) + $array2
			}
			$width1 = $array2 | foreach-object{ $_.length } | sort-object -Descending | select-object -First 1
		
			if($width1 -gt ($windowwidth1  - ($columnstarts1.count + 1) )){
				$width1 = ($windowwidth1  - ($columnstarts1.count  + 1) )
			}
		
			$result1 = @(for($i=0 ; $i -lt $array2.count; $i++){
				
			$line1 = ""
			$line2 = ""
			$line3 = ""
			for($j=0 ; $j -lt $width1; $j++){
				
				if($i -eq 0){
				if($j -eq 0){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($lefttop + $horizontal)
					$line2+= ($vertical +  " ")
					if($i -eq ($array2.count -1)){
						$line3 += ($leftbottom + $horizontal)
					}
					}
					else{
					$line1+= ($lefttop + $horizontal)
					$line2+= ($vertical + @($array2)[$i][$j])    
					if($i -eq ($array2.count -1)){
						$line3 += ($leftbottom + $horizontal)
					}                                    
					}                  
				}
				elseif($columnstarts1.index -contains $j){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($middletop + $horizontal)
					$line2+= ($vertical +  " ")
					if($i -eq ($array2.count -1)){
						$line3 += ($middlebottom + $horizontal)
					}                    
					}
					else{
					$line1+= ($middletop + $horizontal)
					$line2+= ($vertical + @($array2)[$i][$j]) 
					if($i -eq ($array2.count -1)){
						$line3 += ($middlebottom + $horizontal)
					}                                         
					}
				}
				elseif(($width1-1) -eq $j){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($horizontal + $righttop)
					$line2+= (" " + $vertical)
					if($i -eq ($array2.count -1)){
						$line3+= ($horizontal + $rightbottom)                      
					}                     
					}
					else{
					$line1+= ($horizontal + $righttop)
					$line2+= (@($array2)[$i][$j] + $vertical)
					if($i -eq ($array2.count -1)){
						$line3+= ($horizontal + $rightbottom)                      
					}                    
					}                  
				}
				else{
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($horizontal )
					$line2+= (" " )
					if($i -eq ($array2.count -1)){
						$line3+= $horizontal
					}                     
					}
					else{
					$line1+= ($horizontal )
					$line2+= (@($array2)[$i][$j])
					if($i -eq ($array2.count -1)){
						$line3+= $horizontal
					}                      
					}  
				}
				}
				elseif($i -eq ($array2.count -1)){
				if($j -eq 0){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1 += ($middleleft + $horizontal)                    
					$line2 += ($vertical +  " ")
					$line3 += ($leftbottom + $horizontal)
					}
					else{
					$line1 += ($middleleft + $horizontal)                    
					$line2 += ($vertical + @($array2)[$i][$j])
					$line3 += ($leftbottom + $horizontal)
					}
				}
				elseif($columnstarts1.index -contains $j){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($cross  + $horizontal)
					$line2+= ($vertical +  " ")
					$line3+= ($middlebottom + $horizontal)
					}
					else{
					$line1+= ($cross  + $horizontal)
					$line2+= ($vertical + @($array2)[$i][$j])    
					$line3+= ($middlebottom + $horizontal)                
					}
				}
				elseif(($width1-1) -eq $j){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($horizontal + $middleright)
					$line2+= (" " + $vertical)
					$line3+= ($horizontal + $rightbottom)
					}
					else{
					$line1+= ($horizontal + $middleright)
					$line2+= (@($array2)[$i][$j] + $vertical)
					$line3+= ($horizontal + $rightbottom)
					}                  
				}
				else{ 
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($horizontal )
					$line2+= (" " )
					$line3+= ($horizontal )
					}
					else{
					$line1+= ($horizontal )
					$line2+= (@($array2)[$i][$j])
					$line3+= ($horizontal )
					}
				}                               
				}
				else{
				if($j -eq 0){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1 += ($middleleft + $horizontal)
					$line2 += ($vertical +  " ")
					}
					else{
					$line1 += ($middleleft + $horizontal)                    
					$line2 += ($vertical + @($array2)[$i][$j])
					}
				}
				elseif($columnstarts1.index -contains $j){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($cross  + $horizontal)
					$line2+= ($vertical +  " ")
					}
					else{
					$line1+= ($cross  + $horizontal)
					$line2+= ($vertical +  @($array2)[$i][$j])
					}
				}
				elseif(($width1-1) -eq $j){
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($horizontal + $middleright)
					$line2+= (" " + $vertical)
					}
					else{
					$line1+= ($horizontal + $middleright)
					$line2+= (@($array2)[$i][$j] + $vertical)                    
					}                  
				}
				else{
					if(@($null," ") -contains @($array2)[$i][$j]){
					$line1+= ($horizontal )
					$line2+= (" " )
					}
					else{
					$line1+= ($horizontal )
					$line2+= (@($array2)[$i][$j])
					}  
				}                   
				}
			}
				
			if($i -eq ($array2.count -1)){
				$line1,$line2,$line3 -join("`r`n")
			}
			else{
				$line1,$line2 -join("`r`n")
			}
			})
		
			return $result1
		}
	
		#try to work with ise
		try{
		$windowwidth1 = [console]::WindowWidth
		}
		catch{
			try{
				$windowwidth1 = $Host.UI.RawUI.BufferSize.Width - 1
			}
			catch{
				$windowwidth1 = 140
			}
		}
	
		if(@(1,2) -contains $displaymode){
		#property
		if(($array  | get-member | group-object TypeName).Name -ne "System.String"){
			$availableproperties = $array | get-member | where-object{
			@("aliasproperty","noteproperty","property") -contains $_.MemberType
			}
		}
		else{
			$availableproperties = $null
		}
	
		if($availableproperties ){
			if($availableproperties.name -contains $property){
			$property1 = $property
			}
			elseif($availableproperties.name -contains "Name"){
			$property1 = "Name"
			}
			elseif($availableproperties.name -contains "Title"){
			$property1 = "Title"
			}        
			elseif(($availableproperties.name | foreach-object{$_ -match "description|name|(id$)"}) -contains  $true){
			$property1 = $availableproperties | where-object{
				$_.name -match "description|name|(id$)"
			} | select-object -First 1 | select-object -ExpandProperty name
			}
			else{
			$property1 = $availableproperties | select-object -First 1 | select-object -ExpandProperty name
			}      
		}
		else{
			$array = $array | select-object @{l="property";e={$_}}
			$property1 = "property"
		}
	
		#add index numbers
		if($index){
			$display_array1 = @(foreach($item in @($array)){
				[pscustomobject]@{
					"name" = "$( "[{0,$(([string]($array.count - 1)).length)}] {1} " -f $array.indexof($item),$item.$property1-replace("\s"," "))"
				}
			}) 
		}
		else{
			$display_array1 = @(foreach($item in @($array)){
				[pscustomobject]@{
					"name" = "$( "{0} " -f ($item.$property1 -replace("\t"," ")))"
				}
			}) 
		}
		
	
		#columns
		if(!$columns){
	
			$widest = ($display_array1 | foreach-object{
			$_.name.Split([Environment]::NewLine) | foreach-object {$_.length}
			}) | Sort-Object -Descending | Select-Object -First 1
	
			if($boxmode){
			#account for table padding
			$widest+=4
			}
			else{
			$widest+=2
			}
	
			if($display_array1.count -le [math]::Floor($windowwidth1 / $widest) ){
			$columns = $display_array1.count 
			}
			elseif($displaymode -eq 2){
			#top bottom single property
			$rows1 = [math]::Ceiling( $display_array1.count / ([math]::Floor($windowwidth1 / $widest))  )
			$columns = [math]::Ceiling($display_array1.count / $rows1)
	
			}
			else{
			$columns = [math]::ceiling($windowwidth1 / $widest)
			}
			
			
	
	
		}
		$headers1 = @(for($i = 1; $i -le $columns; $i++){ "[string]$" + "c_$($i)"}) -join(";")
		$expression1 = @"
			class Jamessclass {
				$( $headers1 )
			}
"@
		invoke-expression $expression1    
	
		if($displaymode -eq 1){
			#mode 1
			#1,2,3 along the top
	
			$resulttable = @()  
			for($i = 0; $i -lt $display_array1.count; $i += $columns){
			$ourobject = New-Object -TypeName Jamessclass
			for($j = 0; $j -lt $columns; $j++){
				$property2 = "c_$($j + 1)"
				$ourobject.$property2 = $display_array1[$i + $j].name 
			}
			$resulttable += $ourobject
			}
		}
		elseif($displaymode -eq 2){
			#mode 2
			#1,2,3 top to bottom
	
			#build the empty table
			$resulttable = @()  
			for($i = 0; $i -lt $display_array1.count; $i += $columns){
			$ourobject = New-Object -TypeName Jamessclass
			$resulttable += $ourobject
			}
	
			#populate it
			for($i = 0; $i -lt $display_array1.count; $i += $resulttable.count){
			for($j = 0; $j -lt $resulttable.count; $j++){
				$property2 = "c_$([math]::Floor($i/$resulttable.count) + 1)"
				$resulttable[$j].$property2 = $display_array1[$i + $j].name 
			}
			}
		}
	
		
		if($boxmode){
			James-Write-boxMode -array $resulttable -displaymode $displaymode  | Out-Host
		}
		else{
			$resulttable | format-table * -Wrap -HideTableHeaders | Out-Host
		}
		
	
		}
		elseif($displaymode -eq 3){
	
		#simple list without properties
		if( 
			($array | get-member | ForEach-Object {
				@("aliasproperty","noteproperty","property") -contains $_.MemberType
			}
			) -notcontains $true -or `
			($array | get-member).TypeName -eq "System.String"
		){
			if($index){
			$resulttable = @(foreach($item in @($array)){
				$item | select-object `
				@{l="Index";e={
					"$( "[{0,$(([string]($array.count - 1)).length)}]" -f $array.indexof($item))"
				}},@{l="property";e={ $item }}
			}) 
			}
			else{
			$resulttable = @(foreach($item in @($array)){
				$item | select-object @{l="property";e={ $item }}
			})
			}
			
		}
		else{
			if($index){
			$resulttable = @(foreach($item in @($array)){
				$item | select-object `
				@{l="Index";e={
					"$( "[{0,$(([string]($array.count - 1)).length)}]" -f $array.indexof($item))"
				}},*
			}) 
			}
			else{
			$resulttable = @($array)
			}        
		}
	
		#write output
		if($boxmode){
			James-Write-boxMode -array $resulttable -displaymode $displaymode | Out-Host
		}
		else{
			$resulttable | format-table * -Wrap  | Out-Host
		}
		}
	
		
		#no return
	}


	#use this to send editable keys to the console
	Add-Type -AssemblyName System.Windows.Forms
	
	#constants
	$max_iterations = 5
	
	#display
	write-host ("-" * $windowwidth1 + "`r") -ForegroundColor Blue
	if($columns){
		James-Write-ArrayItem -array $array -property $property  -displaymode $displaymode -boxmode $boxmode -index $index -columns $columns
	}
	else{        
		James-Write-ArrayItem -array $array -property $property  -displaymode $displaymode -boxmode $boxmode -index $index
	}
	
	$iteration1 = 0
	
	if($single){
	if($array.count -lt 11){
		write-host "Please type in (without ENTER):"  -ForegroundColor blue
	}
	else{
		write-host "Please type in (with ENTER):"  -ForegroundColor cyan
	}
	$selection_array1 = @("q") + @(0..($array.count) | foreach-object{ [string]$_ })
	$motd1= @"
	-> The index of a single item
	-> 'q' to cancel
"@
	}
	else{
		write-host "Please type in (with ENTER):"  -ForegroundColor cyan
		$selection_array1 = @("q","c") + @(0..($array.count) | foreach-object{ [string]$_ })
		$motd1= @"
		-> The value of an index (__you can prefix an index with 'e' to exclude it eg: e0 or e17 etc__)
		-> a comma-delimited list of indices
		-> 'a' for all items
		-> 'q' to cancel
"@ 
	}
	Write-Host $motd1 -ForegroundColor White
	
	if($array.count -lt 11 -and $single){
		write-host "Input: "  -ForegroundColor Yellow -NoNewline
		#selection doesn't require two key presses
		:menu1 while ($true){
			if($Host.UI.RawUI.KeyAvailable ){
	
				#assign the host key value to a variable
				$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
				#flush the host key
				$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") | out-null
				$host.UI.RawUI.Flushinputbuffer()
				#key pressed
				if( $selection_array1 -contains $key.character){
					write-host $key.character -ForegroundColor Gray
					$selection1 = "$($key.Character)"
					break menu1
				}
			}
		}
	}
	else{
		:menu2 do{
			$iteration1++
			write-host "Input: "  -ForegroundColor Yellow -NoNewline
			if($single){
				$selection_array1 = @("q")
			}
			else{
				$selection_array1 = @("a","q")
			}
			:menu3 while ($true){
				if($Host.UI.RawUI.KeyAvailable ){
					#assign the host key value to a variable
					$key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
					#flush the host key
					$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") | out-null
					$host.UI.RawUI.Flushinputbuffer()
					#key pressed
					if($selection_array1 -contains $key.character){
						#selection 1 fulfilled : no need to press enter
						write-host $key.character -ForegroundColor Gray
						$selection1 = "$($key.Character)"
						break menu2
					}
					else{
						#go on to write more input
						break menu3
					}
				}
			}
	
			#send key to the console instead of burning it into the console.
			if($key.VirtualKeyCode -eq 13){
				Write-Host ""
				$selection1 = $null
			}
			else{                
				#if enter was not pressed
				[System.Windows.Forms.SendKeys]::SendWait($key.Character)
				[string]$selection1 = Read-Host
			}
			$selection1 = ($selection1  -replace("\s{2,}"," ")).trim()  -replace("[\t\r\n\s]",",")
			$selection_array2 = @("a","q") + @(0..($array.count - 1)) + @((-1*($array.count))..-1)
			$selection_test1 = $selection1 -match "\w" -and `
				(
					#input prefixed with e get excluded
					$selection_array2 -contains ($selection1 -replace("e","")) -or `
					(
						$selection1 -like "*,*" -and (
							compare-object `
								@($selection1 -replace("e","") -split(",")) `
								$selection_array2 -IncludeEqual | `
								where-object{$_.sideindicator -eq "=="}
						)
					)
				) -or `
				$iteration1 -ge $max_iterations
		}while(!$selection_test1)
	}
	if($selection1){
		if($selection1 -match "(e\d)+"){
			#exclude some indices
			if([string]$selection1.trim() -match "\,"){
				if(@([string]$selection1.trim() -split(",") | ForEach-Object { $_ -match "e\d+"})  -contains $false){
					#if an array contains exclusions and inclusions just process the inclusions
					#select several items using an array of indices
					$result1 = @(foreach($jtem in @(($selection1.trim()) -split(","))){
						if($jtem -match "^-?\d+$" ){
							@($array)[$jtem]
						}
					})
				}
				elseif(@([string]$selection1.trim() -split(",") | ForEach-Object { $_ -match "e\d+"})  -notcontains $false){
					#select all the array 
					[System.Collections.ArrayList]$result1 = $array
					#and exclude a few items
					@(foreach($jtem in (($selection1.trim()) -split(",") | Sort-Object -Descending)){
						$result1.removeat([int]($jtem -Replace("e","")))
					})
				}
			}
			else{
				#select everything and exclude one item only
				#cast thereturn variable as arraylist, don't need to cast it again.
				[System.Collections.ArrayList]$result1 = $array
				#assign the updated array to the return variable
				$result1.removeat([int]($selection1 -Replace("e","")))
			}
		}
		elseif($selection1.trim() -eq "a"){
			#selecting a for all
			if($single){
				#can't select all items when specified to only select a single one
				$result1 = @()
			}
			else{
				$result1 = @($array)
			}
		}
		elseif($selection1.trim() -eq "q" -or !$selection1){
			#selecting q to quit/cancel
			$result1 = $null
		}
		elseif($selection1.trim() -like "*,*"){
			#select several items using an array of indices
			$result1 = @(foreach($jtem in (($selection1.trim()) -split(","))){
				if($jtem -match "^-?\d+$" ){
					@($array)[$jtem]
				}
			})
		}
		else{
			#select one item only
			$result1 = @($array)[$selection1]
		}
	}
	else{
		$result1 = $null
	}
	return $result1
	
	<#
	.SYNOPSIS
	This function writes the contents of an array to the console and prompts the user to select one or more items from it.
	
	.DESCRIPTION
	This function prompts the user to select items from an array list.
	It is designed for use in other apps and function.
	
	Features:
	The function works with PowerShell.exe 5.x pwsh.exe 7.x and vscode PowerShell, but it is incompatible with PowerShell ISE.
	It outputs an object of the same type as the input object (unless output is $null).
	The function expects users to confirm input with ENTER except when:
	-the user presses 'a' for all items,
	-the user presses 'q' to quit the selection and select no items,
	-there are 10 or less items (indices 0 to 9) and a user is expected to select one item.
	The function has an exclusion feature: if prompted to select many items, the user can type in a comma-delimited list of indices to exclude. Each index must be prefixed with the letter e, eg:
	e0,e4,e9
	
	.PARAMETER array
	The function can input arrays made from objects with attribute names and arrays without property names.
	
	.PARAMETER displaymode
	The function features three ways of displaying the array to the user.
	
	displaymode 1 writes the array on the screen in row-major.
	displaymode 2 writes the array on the screen in column-major.
	displaymode 3 writes the array on the screen as a table (using Format-Table).
	
	Modes 1 and 2 only show the value of one property of each array item. The property shown is 'name' or 'title' is not specified by the property parameter.
	
	Modes 1 and 2 use as much of the screen as is possible.
	
	.PARAMETER property
	Use the property parameter to define which property will be used by display modes 1 and 2. By default the function uses array property 'name' or 'title' if available.
	
	.PARAMETER boxmode
	When $true, write the array on the screen in a grid box. Works with all display modes.
	
	.PARAMETER index
	When $true, write the array to the screen and add the index of each array item. 
	
	.PARAMETER single
	When $true, force  the user to only select one item, or none.
	
	.PARAMETER columns
	Use the columns parameter to tell the script how many columns should be used with display mode 1 and 2.
	By default all display modes try to use as much of the screen as possible
	
	.EXAMPLE
	$array = get-process | select-object -first 11; James-Get-ArrayItem -array $array
	
┌──────────────┬─────────────────────┬────────────────────────┬──────────┐
│[ 0] abyssws  │[ 3] AdminService    │[ 6] Bridge_Service     │[ 9] Code │
├──────────────┼─────────────────────┼────────────────────────┼──────────┤
│[ 1] abyssws  │[ 4] AggregatorHost  │[ 7] CancelAutoPlay_df  │[10] Code │
├──────────────┼─────────────────────┼────────────────────────┼──────────┤
│[ 2] ACCSvc   │[ 5] audiodg         │[ 8] CheckNDISPort_df   │          │
└──────────────┴─────────────────────┴────────────────────────┴──────────┘
Please type in (with ENTER):
        -> The value of an index (__you can prefix an index with 'e' to exclude it eg: e0 or e17 etc__)
        -> a comma-delimited list of indices
        -> 'a' for all items
        -> 'q' to cancel
Input: 0 1 2

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    145      13    12428       2252       5.53   5592   1 abyssws
    176      12     2308       1276      32.23  13516   1 abyssws
    116       9     2028       7512              4456   0 ACCSvc


    Uses default display mode 2 (column-major) displays only the 'name' or each item of the array, shows the data encapsulated in a boxed grid, and includes the item indices.
    
    .EXAMPLE
    $array = "no","yes","maybe" ; James-Get-ArrayItem -array $array  -displaymode 1 -single $true -boxmode $true

┌────────┬─────────┬──────────┐
│[0] no  │[1] yes  │[2] maybe │
└────────┴─────────┴──────────┘
Please type in (without ENTER):
        -> The index of a single item
        -> 'q' to cancel
Input: 1
yes 

	This example shows how the function could be incorporated into a console text user interface TUI.
	
	.EXAMPLE
	$array = import-csv "myfile.csv"; James-Get-ArrayItem -array $array  -displaymode 3 -single $true -boxmode $false
	
	Uses default display mode 3 (format-table) displays all properties which fit on the screen, and includes the item indices.
	This command doesn't use boxmode so the table is shown in normal PowerShell format-table mode which is more compact that my boxmode.
	
	.EXAMPLE
	$array = @(get-aduser -filter *); James-Get-ArrayItem -array $array  -displaymode 1 -property "userprincipalname" -single $false -boxmode $true
	
	This example shows an array of users in row-major mode, and onlny shows the userprincipal name of each item. By default it would have shown the name of each item.
	
	.EXAMPLE
	$array = 0..99; James-Get-ArrayItem -array $array  -displaymode 2 -single $true -boxmode $true -columns 5
	
	This example lets the user select a number between 0 and 99. The command features the columns parameter with a sensibly low number.
	I have found display mode 2 (column-major, instead of mode 1 row major) to be more legible when there are lots of items on display.
	
	#>    
}
