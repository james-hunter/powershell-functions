
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
    $lines1 = $arraystring -split("`r|`n") | where-object {$_ -match  "[^A-Z]\-"}
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
        class jimmysclass {
          $( $headers1 )
        }
"@
      invoke-expression $expression1    

      if($displaymode -eq 1){
        #mode 1
        #1,2,3 along the top

        $resulttable = @()  
        for($i = 0; $i -lt $display_array1.count; $i += $columns){
          $ourobject = New-Object -TypeName jimmysclass
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
          $ourobject = New-Object -TypeName jimmysclass
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



