Function James-Get-Random{

    param(
        [int]$count
    )

    add-type  -AssemblyName System.Windows.Forms
    $max = $count
    $random1 = @(for($i = 0; $i -lt $max; $i++){
        1/(Get-Random -Minimum 0.0 -Maximum 1.0)
    })
    return $random1
}

