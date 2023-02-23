New-Item 'C:\Windows\Panther' -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

# OOBE > ProtectYourPC skips/hides privacy/tracking/handwriting agreements
# InputLocale 0813:00000813 is the code for nl-BE:Belgium (Point)

$unattend = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" language="neutral" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <OOBE>
        <ProtectYourPC>3</ProtectYourPC>
      </OOBE>
    </component>
  <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" language="neutral" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" publicKeyToken="31bf3856ad364e35" versionScope="nonSxS">
      <InputLocale>0813:00000813</InputLocale>
    </component>
  </settings>
</unattend>
'@
Out-File -InputObject $unattend -FilePath 'C:\Windows\Panther\unattend.xml' -Force -ErrorAction SilentlyContinue | Out-Null