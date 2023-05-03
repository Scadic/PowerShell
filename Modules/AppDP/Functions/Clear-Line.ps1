Function Clear-Line
{

    [CmdLetBinding()]

    Param
    (
        # None
    )

    Begin
    {

    }

    Process
    {

    }

    End
    {
    
        $String = "`r"

        For ($I = 0; $I -Le [System.Console]::BufferWidth; $I++)
        {

            If ($I -Eq [System.Console]::BufferWidth){$String += "`r"}
            Else {$String += " "}

        }

        Write-Host -NoNewline -Object $String

    }

}