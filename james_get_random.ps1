Function Jimmy-Get-Random{

    param(
        [int]$count
    )

    add-type  -AssemblyName System.Windows.Forms
    $max = $count
    $random1 = @(for($i = 0; $i -lt $max; $i++){
        $pre = [System.Windows.Forms.Cursor]::get_Position()
        Write-Progress -Activity "Getting random numbers" -PercentComplete (($i / $max)*100)
        $wait = (Get-Random -Minimum 1 -Maximum 1000)
        Start-Sleep -Milliseconds $wait   
        $post = [System.Windows.Forms.Cursor]::get_Position()
        if($pre -eq $post){
            Write-Host "$(get-date -format "yyyy-MM-dd HH:mm:ss")`tPlease move the mouse to generate random numbers"
            do{
                Start-Sleep -Milliseconds 100
                $post = [System.Windows.Forms.Cursor]::get_Position()
            }until($pre -ne $post)
        }
        if($post.x -gt $post.y){

            if($post.x -eq 0 ){
                0
            }
            else{
                $post.y / $post.x
            }
        }
        else{
            if($post.y -eq 0 ){
                0
            }
            else{
                $post.x / $post.y
            }
        }
    })
    return $random1
}
