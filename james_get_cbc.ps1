

Function James-Get-CBC{

    #import
    if(test-path "james_get_arrayitem.ps1"){
        . "./james_get_arrayitem.ps1"
    }
    if(test-path "james_write_arrayitem.ps1"){
        . "./james_write_arrayitem.ps1"
    }    
    if(test-path "james_write_insidebox.ps1"){
        . "./james_write_insidebox.ps1"
    }    
    if(test-path "james_format_centre.ps1"){
        . "./james_format_centre.ps1"
    }    
    if(!(Get-Command James-Get-ArrayItem)){
        Write-Host "Command not available: James-Get-ArrayItem"
        break
    }    
    if(!(Get-Command James-Write-ArrayItem)){
        Write-Host "Command not available: James-Write-ArrayItem"
        break
    }    
    if(!(Get-Command James-Write-InsideBox)){
        Write-Host "Command not available: James-Write-InsideBox"
        break
    }    
    if(!(Get-Command James-Format-Centre)){
        Write-Host "Command not available: James-Format-Centre"
        break
    }                
    
    Function James-Parse-CanadianDate{

        param(
            [string]$datestring
        )
        
        #parse time zones with time zone code must be doen manually because powershell doesn't keep a dictionary
        $CanadaOffsets = @{
            #Newfoundland
            'NST' = @{
                'offset' = '-03:30';
                'location' = 'Newfoundland'
            }
        
            'NDT' = @{
                'offset' = '-02:30';
                'location' = 'Newfoundland'                
            }

            # Atlantic Time
            'AST' = @{
                'offset' = '-04:00';
                'location' = 'Atlantic'
            }
        
            'ADT' = @{
                'offset' = '-03:00';
                'location' = 'Atlantic'                
            }            


            # Eastern Time
            'EST' = @{
                'offset' = '-05:00';
                'location' = 'Eastern'
            }
        
            'EDT' = @{
                'offset' = '-04:00';
                'location' = 'Eastern'                
            }             


            # Central Time
            'CST' = @{
                'offset' = '-06:00';
                'location' = 'Central'
            }
        
            'CDT' = @{
                'offset' = '-05:00';
                'location' = 'Central'                
            }              

            # Mountain Time
            'MST' = @{
                'offset' = '-07:00';
                'location' = 'Mountain'
            }
        
            'MDT' = @{
                'offset' = '-06:00';
                'location' = 'Mountain'                
            }             


            # Pacific Time
            'PST' = @{
                'offset' = '-08:00';
                'location' = 'Pacific'
            }
        
            'PDT' = @{
                'offset' = '-07:00';
                'location' = 'Pacific'                
            }             

        }

        $datestring2 = $datestring -replace("[A-Z]{3}$", $CanadaOffsets[([regex]::match($datestring ,"[A-Z]{3}$")).value]["offset"])
        $datestring3 = [DateTimeOffset]::ParseExact($datestring2, "ddd, dd MMM yyyy HH:mm:ss zzz", $null) `
            | Select-Object *,@{l="location";e={  $CanadaOffsets[([regex]::match($datestring ,"[A-Z]{3}$")).value]["location"]  }}   

        return $datestring3
    
    }

    #cbc top stories
    $uri = "https://rss.cbc.ca/lineup/topstories.xml"
    
    $topstories_restrequest1= @(
        Invoke-WebRequest `
            -Uri $uri `
            -Method get `
	    -UseBasicParsing
    )

    $topstories_xml1 = [xml]($topstories_restrequest1.content)

    $title1=            ($topstories_xml1.rss.channel.title).InnerText
    $description1=      ($topstories_xml1.rss.channel.description).InnerText
    $link1=             ($topstories_xml1.rss.channel.link)
    $copyright1 =       ($topstories_xml1.rss.channel.copyright).InnerText
    $docs1 =            ($topstories_xml1.rss.channel.docs).InnerText
    $lastbuilddate1 =   James-Parse-CanadianDate -datestring ($topstories_xml1.rss.channel.lastbuilddate)
    $imagepath1 =       ($topstories_xml1.rss.channel.image.url)

    $motd= @"
=== $($title1) ===
Disclaimer: $($description1)

Source:
$($link1)
$($docs1)
$($copyright1)

Published in Canada ($($lastbuilddate1.location) time): $(get-date($lastbuilddate1.datetime) -format "yyyy-MM-dd HH:mm") === My time: $(get-date($lastbuilddate1.localdatetime) -format "yyyy-MM-dd HH:mm")
"@
    James-Write-Insidebox -text (James-Format-Centre -text $motd) -padding 1 -lines double -side centre

    #James-Show-Image -imagepath $imagepath1
    $id = Get-Random -Minimum 0 -Maximum 2000
    $stories1 = @(Select-Xml -Xml $topstories_xml1 -XPath "//item")
    :menu2 foreach($item in $stories1){

        Write-Progress `
            -Activity "CBC top stories" `
            -Status "$($item.Node.type)" `
            -PercentComplete ((@($stories1).indexof($item)/@($stories1).count)*100) `
            -Id $id

        $itemdate1 = James-Parse-CanadianDate -datestring $item.Node.pubdate
        $itemobject1 = [pscustomobject]@{
            "Type"        = $item.node.type
            "Category"    = $item.Node.category   
            "Title"       = $item.Node.title.InnerText
            "Link"        = $item.Node.link
            "Ontario"     = get-date($itemdate1.datetime) -format "yyyy-MM-dd HH:mm"
            "My time"     = get-date($itemdate1.localdatetime) -format "yyyy-MM-dd HH:mm"
            "Description" = [System.Net.WebUtility]::HtmlDecode((
                $item.Node.description.innerxml -split("<p>|</p>") | Select-Object -Last 1 -Skip 1
            ))
        }
            
        James-Write-Insidebox -text ($itemobject1 | Format-List | Out-String) -padding 1 -lines single -side left
        
        if($item.Node.link){
            Write-Host "press 'j' to show the full article, 'n'/[SPACEBAR]/[ENTER] for next, or 'q'/[BACKSPACE] to quit to catalogue"
        }
        else{
            Write-Host "'n'/[SPACEBAR]/[ENTER] for next, or 'q'/[BACKSPACE] to quit to catalogue"
        }
        
        #replaces read-host
        :menu3 while ($true){
            if($Host.UI.RawUI.KeyAvailable ){
                #assign the host key value to a variable
                $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                #flush the host key
                $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") | out-null
                $host.UI.RawUI.Flushinputbuffer()
                #key pressed
                if( @($null," ","n") -contains $key.character -or $key.VirtualKeyCode -eq 13 ){
                    break menu3
                }
                elseif( "j" -eq $key.character){
                    if($item.Node.link){
                        start-process $item.Node.link
                    }
                }                                                                
                elseif( "q" -eq $key.character -or $key.VirtualKeyCode -eq 8){
                    break menu2
                }                                
            }
        } 
    }

    Write-Progress `
        -Activity "CBC top stories" `
        -Completed `
        -Id $id
   
}
