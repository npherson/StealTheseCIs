#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

Import-CMConfigurationItem -FileName "$psscriptroot\Dummy - Limit Network access account on non-site systems.cab"

$NAANames = (Get-CMAccount | ? {$_.accountusage -eq "Software Distribution"}).Username
$naanamesarray = [String]::Empty
$newvalue ="'"
foreach ($name in $naanames)
{
    $newvalue = $newvalue + $name + ','
    
}

$newvalue = $newvalue.Substring(0,$newvalue.Length-1) + "'"

$arrCI = (Get-CMConfigurationItem | ? {$_.localizeddisplayname -like "Protect Network Access Account - *"} | select localizeddisplayname)

foreach ($item in $arrci)
{

$ciXML = [XML](Get-CMConfigurationItem | ? {$_.localizeddisplayname -eq $item.localizeddisplayname}).SDMPackageXML
$ciCD = [System.Xml.XmlElement]($ciXML.DesiredConfigurationDigest)
$writer = New-Object XML.XmlTextWriter "$env:temp\cidigest.xml", ([Text.Encoding]::Unicode)
$cicd.WriteTo($writer)
$writer.Flush()
$writer.Close()
(Get-Content $env:temp\CIDigest.xml).Replace("`$NAAAccount = @('dummy\dummy01')","`$NAAAccount = @($newValue')") | Set-Content $env:temp\CIDigest.xml
Set-CMConfigurationItem -DesiredConfigurationDigestPath $env:temp\CIDigest.xml -Name $item.localizeddisplayname 
remove-item $env:temp\CIDigest.xml -Force
}



