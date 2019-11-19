# New-QrCode

Simple module used to generate QR Codes within PowerShell using **[QRCoder Assembly](https://github.com/codebude/QRCoder/Wiki)**. All credits to original author(s). 

## Supported payloads

**QrCodeGenerator** supports all *paylods* supported by original assembly which are described [here](https://github.com/codebude/QRCoder/wiki/Advanced-usage---Payload-generators)

## How to use

*QrCoder* aims to be as simple as possible while maintaining flexibility. Generating a QR code for a WiFi network is as simple as using the following: 

```powershell
    New-QrWifiAccess -SSID 'MyNetwork' -NetworkPassword 'MyPassword' -Width 100
```

The above example will create a QR containing access information for a network with SSID *MyNetwork* requiring a password to access, file will be created under **$env:temp\qrcode.png** path which can be modified with the *-OutputPath* parameter followed by a valid path and filename.

## External requirements

Module relies on *QrCoder* dll which is embedded in module's manifest as string.

**Note:** Instructions on how to embed assemblies via string can be [found here](https://pscustomobject.github.io/powershell/howto/PowerShell-Add-Assembly/).
