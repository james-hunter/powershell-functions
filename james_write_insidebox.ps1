
Function James-Write-Insidebox{

    param(
        [string][Parameter(Mandatory = $true, Position=0)]$text,
        [string][Parameter(Mandatory = $false, Position=0)][ValidateSet(1, 2, 3)]$padding = 1,
        [string][Parameter(Mandatory = $false, Position=0)][ValidateSet("single","double")]$lines = "single",
        [string][Parameter(Mandatory = $false, Position=0)][ValidateSet("centre","left","right")]$side = "centre"
    )

    $width1 = [console]::WindowWidth

    $borderwidth1 = 1

    $text1 = $text -replace("`t", " ")
    $textarray1 = ($text1 -split("`r`n|`r|`n"))
    $textwidth1 = ( ($textarray1) | ForEach-Object{  $_.length  } | Sort-Object)[-1]
    $emptyspace1 = $width1 - $textwidth1 - ($borderwidth1 * 2)

    if($emptyspace1 -lt 0){
        $textwidth1 = $width1 - ($borderwidth1 * 2)
        $textarray2 = @(foreach($line in @([string]$textarray1 -split("`r|`n"))  ){
            if(([string]$line).Length -le ($width1 - ($borderwidth1 * 2))){
                $line
            }
            else{
                (([string]$line) -split  "(.{$textwidth1})") | Where-Object {$_} | foreach-object{
                    $_
                }
            }
        })

        $textwidth1 = ( $textarray2 | ForEach-Object{  $_.length  } | Sort-Object)[-1]
        $emptyspace1 = $width1 - $textwidth1 - ($borderwidth1 * 2)

    }
    else{

        $textarray2 = $textarray1
    }



    #text fits on the window
    #padding
    #1 close to the text
    #2 middle
    #3 maxed
    switch($padding){
        1{
            $halfempty1 = [math]::floor($emptyspace1 /2)
            $halfempty2 = ""
            $verticalempty1 = 0
            $straighthorizontal1 = $halfempty2 * 2 + $textwidth1
            break
        }
        2{
            $halfempty1 = [math]::floor(($emptyspace1 /2) / 2)
            $halfempty2 =  [math]::floor($emptyspace1/2) - [math]::floor(($emptyspace1 /2) / 2)
            $verticalempty1 = 1
            $straighthorizontal1 = $halfempty2 * 2 + $textwidth1
            break
        }
        3{
            $halfempty1 = 0
            $halfempty2 = [math]::floor($emptyspace1 /2)
            $verticalempty1 = 2
            $straighthorizontal1 = $halfempty2 * 2 + $textwidth1
            break
        }

    }

    switch($side){
        "left"{
            $halfempty1 = 0
            break
        }
        "right"{
            $halfempty1 =  $width1 - $straighthorizontal1 - 2
        }
    }


    #lines
    if($lines -eq "single"){
        $style = 0
    }
    else{
        $style = 1
    }
    $middleleft = @([char]9500, [char]9568)[$style] # ├
    $middleright = @([char]9508, [char]9571)[$style] # ┤
    $middletop= @([char]9516, [char]9574)[$style] #  ┬
    $middlebottom = @([char]9524, [char]9577)[$style] # ┴
    $cross = @([char]9532, [char]9580)[$style] # ┼
    $horizontal = @([char]9472, [char]9552)[$style] # ─
    $vertical = @([char]9474, [char]9553)[$style] # │
    $lefttop = @([char]9484, [char]9556)[$style] # ┌
    $righttop = @([char]9488, [char]9559)[$style] # ┐
    $leftbottom = @([char]9492, [char]9562)[$style] # └
    $rightbottom = @([char]9496, [char]9565)[$style] # ┘


    #draw
    #top
    [string]$output1 = ([string]" " * $halfempty1)
    $output1 += $lefttop
    $output1 += ( [string]$horizontal * ($straighthorizontal1 ) )
    $output1 += $righttop
    $output1 += "`r`n"

    #top middle
    for($i = 0; $i -lt $verticalempty1; $i++){
        $output1 += ([string]" " * $halfempty1)
        $output1 += $vertical
        $output1 += ( [string]" " * ($straighthorizontal1 ) )
        $output1 += $vertical
        $output1 += "`r`n"
    }

    #text middle
    foreach($line in $textarray2){
        $output1 += ([string]" " * $halfempty1)
        $output1 += $vertical
        $output1 += ( [string]" " * ($halfempty2 ) )
        $output1 += $line
        $output1 += ([string]" " * ( $textwidth1 -  $line.length ))
        $output1 += ( [string]" " * ($halfempty2 ) )
        $output1 += $vertical
        $output1 += "`r`n"
    }


    #bottom middle
    for($i = 0; $i -lt $verticalempty1; $i++){
        $output1 += ([string]" " * $halfempty1)
        $output1 += $vertical
        $output1 += ( [string]" " * ($straighthorizontal1 ) )
        $output1 += $vertical
        $output1 += "`r`n"
    }

    #bottom
    [string]$output1 += ([string]" " * $halfempty1)
    $output1 += $leftbottom
    $output1 += ( [string]$horizontal * ($straighthorizontal1 ) )
    $output1 += $rightbottom
    $output1 += "`r`n"

    return $output1



}
