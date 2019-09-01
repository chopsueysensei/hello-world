$ssfFonts = 0x14
$fontSourceFolder = ".\bootstrap\fonts\"
$Shell = New-Object -ComObject Shell.Application
$SystemFontsFolder = $Shell.Namespace($ssfFonts)
$FontFiles = Get-ChildItem $fontSourceFolder -recurse -exclude *.txt
$SystemFontsPath = $SystemFontsFolder.Self.Path
$rebootFlag = $false

foreach($FontFile in $FontFiles) {
    # Skip directories
    if(Test-Path $FontFile -pathType container){
        continue
    }

    Write-Host ("Installing " + $FontFile.Name + " ..")

    # $FontFile will be copied to this path:
    $targetPath = Join-Path $SystemFontsPath $FontFile.Name
    # So, see if target exists...
    if(Test-Path $targetPath){
        # font file with the same name already there.
        # delete and replace.
        $rebootFlag = $true
        Remove-Item $targetPath -Force
        Copy-Item $FontFile.FullName $targetPath -Force
    }else{
        #install the font.
        $SystemFontsFolder.CopyHere($FontFile.fullname)
    }
}

#Follow-up message
if($rebootFlag){
    Write-Host "At least one existing font overwritten. A reboot may be necessary."
}
