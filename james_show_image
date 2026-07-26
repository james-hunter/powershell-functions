
Function James-Show-Image{
	
	param(
		[string][Parameter(Mandatory = $true, Position=0)]$imagepath
	)
	
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	#keep count of object groups:
	$Formheight = 400
	$FormWidth = 400
	
	# Build Form
	$Form1 = New-Object System.Windows.Forms.Form
	$Form1.Text = "Hunter Informatique v1"
	$Form1.Size = New-Object System.Drawing.Size($Formwidth,$Formheight)
	$Form1.StartPosition = "CenterScreen"
	$Form1.Topmost = $True
	#$Form1.FormBorderStyle = "FixedDialog"
	$Form1.MinimumSize = New-Object System.Drawing.Size(($Formwidth/1),($Formheight / 1))
	
	#picture box
	# Add Picture box: pictures will be added with the function
	$Picturebox1 = New-Object System.Windows.Forms.Picturebox
	$Picturebox1.dock = "fill"
	$Picturebox1.sizemode = 4
	
	$form1.controls.add($pictureBox1)    
	
	#picture
	if($imagepath -match "^http"){
		$imageuri1 = [uri]$imagepath
		$imagepath = "c:/temp/$(get-date -format "yyyyMMdd_HHmmssttt")view.$($imageuri1.Segments[-1] -split("\.") | Select-Object -Last 1)"
		$webclient = new-object System.Net.WebClient
		$webclient.Headers.Add(
			"User-Agent",
			"Mozilla/5.0"
		)        
		try{
			$webclient.DownloadFile(
				$imageuri1.AbsoluteUri,
				$imagepath
			)
		}
		catch [System.Net.WebException] {
			Write-Host "Web exception:"
			Write-Host $_.Exception.Message
		}
		catch {
			Write-Host "Other exception:"
			Write-Host $_.Exception.Message
		}        
	
	}
	if(test-path $imagepath){
		$Picturebox1.Image = [System.Drawing.Image]::Fromfile($imagepath ) 
		#Show the Form
		$Form1.ShowDialog()| Out-Null
	}
	
	
	#end
	$form1.Close()
	
	#clean up temp file
	Get-ChildItem c:/temp/ | where-object{
		$_.name -match "\.(jpg|png|gif|jpeg|webm|mp4)$"
	} | ForEach-Object{
		try{
			Remove-Item $_.fullname -Confirm:$false -ErrorAction Stop
		}
		catch{
	
		}
	}
}
