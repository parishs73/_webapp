# Continuous Traffic Loop for Azure Demos
$url = "demodash-caeu6qo5wdic4-web-app.azurewebsites.net"
Write-Host "Sending continuous traffic to $url... Press CTRL+C to stop." -ForegroundColor Cyan

while ($true) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
        Write-Host "Hit sent! Status: $($response.StatusCode) at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Green
    }
    catch {
        Write-Host "Hit sent! (Request tracked) at $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Yellow
    }
    Start-Sleep -Milliseconds 500 # Sends 2 requests every second
}