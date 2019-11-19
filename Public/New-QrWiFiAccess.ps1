function New-WiFiQrCode
{
	<#
		.SYNOPSIS
			Creates a QR Code graphic file containing WiFi Access details.
		
		.DESCRIPTION
			Creates a QR code graphic in png format that - when scanned by a smart device - connects you to a Wifi access point
		
			Creates a QR ccode graphic file in the specified format, defaults to png, that when scanned with a smart phone/tablet will connect to the WiFi network
		
		.PARAMETER NetworkSSID
			A string representing the Network SSID.
		
		.PARAMETER NetworkPassword
			A string representing the password to be used while connecting to the network.
		
		.PARAMETER CodeWidth
			An integer representing height and width of the generated file in pixels default is 25.
		
		.PARAMETER ShowCode
			Open the generated QRCode using the default registered application.
		
		.PARAMETER OutputPath
			Path to generated png file. When omitted, a temporary file name is used. #TODO: Change this
		
		.PARAMETER WiFiAuthMode
			A string representing the authentication protocol used to protet the WiFi network. 
	
			Possible values are: 
	
			- WEP
			- WPA
			- WPA2 
	
			If not specified it will default to WPA2.
		
		.PARAMETER HiddenSSID
			Boolean value indicating if network is not broadcasting its SSID. Default is $False
		
		.EXAMPLE
			New-QrWifiAccess -SSID 'MyNetwork' -NetworkPassword 'MyPassword' -Width 100 -ShowCode -OutPath "$home\Desktop\qr.png"
			
			Creates a QR code png graphics on the user desktop and opens it with the default associated application.
		
		.NOTES
			Compatible with PowerShell 5.1, 6 Core, 7
			
			Assembly for QR generation from https://github.com/codebude/QRCoder/wiki
	#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]
		$NetworkSSID,
		[Parameter(Mandatory = $true)]
		[string]
		$NetworkPassword,
		[ValidateRange(10, 2000)]
		[int]
		$CodeWidth = 25,
		[switch]
		$ShowCode,
		[string]
		$OutputPath = "$env:temp\qrcode.png",
		[ValidateNotNullOrEmpty()]
		[ValidateSet('WEP', 'WAP', 'WAP2', IgnoreCase = $true)]
		[string]
		$WiFiAuthMode = 'WPA2',
		[switch]
		$HiddenSSID
	)
	
	# Initialize payload
	[string]$qrPayload = "WIFI:S:$NetworkSSID;P:$NetworkPassword;"
	
	# Get cmdlet parameters
	foreach ($key in $PSBoundParameters.Keys)
	{
		switch ($key)
		{
			'HiddenSSID'
			{
				$qrPayload += 'H:True;'
			}
			'WiFiAuthMode'
			{
				$qrPayload += "T:$WiFiAuthMode;"
			}
		}
	}
	
	# Instantiate new object
	$paramNewObject = @{
		TypeName = 'QRCoder.QRCodeGenerator'
	}
	
	[QRCoder.QRCodeGenerator]$qrGenerator = New-Object @paramNewObject
	
	# Define QR data with ECC level
	[QRCoder.QRCodeData]$qrData = $qrGenerator.CreateQrCode($qrPayload, 'Q')
	
	# Instantiate new QR code object
	$paramNewObject = @{
		TypeName	 = 'QRCoder.PngByteQRCode'
		ArgumentList = ($qrData)
	}
	
	[QRCoder.PngByteQRCode]$qrCode = New-Object @paramNewObject
	
	# Convert object to byte
	[byte]$byteArray = $qrCode.GetGraphic($CodeWidth)
	
	# Write QR to file	
	[System.IO.File]::WriteAllBytes($OutputPath, $byteArray)
	
	if ($PSBoundParameters.ContainsKey('ShowCode'))
	{
		# Open code in default app
		Invoke-Item -Path $OutputPath 
	}
}