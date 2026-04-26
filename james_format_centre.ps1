Function James-Format-Centre{

    param(
        [string][Parameter(Mandatory = $true, Position=0)]$text,
        [string][Parameter(Mandatory = $false, Position=1)][ValidateSet(1, 2)]$padding = 1
    )



    $width1 = ([console]::WindowWidth )

    $text1 = $text -replace("`t", " ")
    $textarray1 = ($text1 -split("`r`n|`r|`n") )

    $textarray2 = @(foreach($line in $textarray1){
        try{
            ($line).trim()
        }
        catch{
            $line
        }
    })

    $textarray3 = @(foreach($line in @($textarray2)){
        if(([string]$line).Length -le ($width1)){
            $line
        }
        else{
            (([string]$line) -split  "(.{$width1})") | Where-Object {$_} | foreach-object{
                $_
            }
        }
    })

    $textwidth1 = ( ($textarray1) | ForEach-Object{  $_.length  } | Sort-Object)[-1]

    #text fits on the window
    #padding
    #1 compact
    #2 maxed
    switch($padding){
        1{
            $width2 = $textwidth1
            break
        }
        2{
            $width2 = $width1
            break
        }
    }

    [string]$output1 = ""
    foreach($line in $textarray3){
        $emptyspace1 = ($width2 - ($line.length))
        $halfempty1 = [math]::floor($emptyspace1 /2)

        $output1 += ( [string]" " * ($halfempty1 ) )
        $output1 += $line
        $output1 += "`r`n"

    }

    return $output1

}
