Function Invoke-WakeOnLan
{
  Param
  (
    # one or more MAC Addresses
    [Parameter(
        Mandatory = $True,
        HelpMessage = "Mac Addresses to wake up.",
        Position = 0,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True
        )
    ]
    # mac address must be a following this regex pattern:
    [ValidatePattern('^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$')]
    [System.String[]] $MacAddress 
  )
 
  Begin
  {
    # instantiate a UDP client:
    $UDPclient = [System.Net.Sockets.UdpClient]::new()
  }

  Process
  {
    ForEach($_ in $MacAddress)
    {
      Try {
        $CurrentMacAddress = $_
        
        # get byte array from mac address:
        $MAC = $CurrentMacAddress -split '[:-]' |
          # convert the hex number into byte:
          ForEach-Object {
            [System.Convert]::ToByte($_, 16)
          }
 
        #region compose the "magic packet"
        
        # create a byte array with 102 bytes initialized to 255 each:
        $Packet = [byte[]](,0xFF * 102)
        
        # leave the first 6 bytes untouched, and
        # repeat the target mac address bytes in bytes 7 through 102:
        6..101 | Foreach-Object { 
          # $_ is indexing in the byte array,
          # $_ % 6 produces repeating indices between 0 and 5
          # (modulo operator)
          $Packet[$_] = $MAC[($_ % 6)]
        }
        
        #endregion
        
        # connect to port 400 on broadcast address:
        $UDPclient.Connect(([System.Net.IPAddress]::Broadcast),4000)
        
        # send the magic packet to the broadcast address:
        $Null = $UDPclient.Send($Packet, $Packet.Length)
        Write-Verbose -Message "sent magic packet to $CurrentMacAddress..."
      }
      Catch 
      {
        Write-Warning -Message "Unable to send ${MAC}: $_"
      }
    }
  }
  End
  {
    # release the UDF client and free its memory:
    $UDPclient.Close()
    $UDPclient.Dispose()
  }
}