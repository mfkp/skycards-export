param(
    [string]$Email,
    [System.Security.SecureString]$Password,
    [string]$OutputFile = "skycards_user.json"
)

$ErrorActionPreference = "Stop"

$SkycardsVersion = "2.2.4"
$OkhttpVersion = "4.12.0"

function Fail {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    [Console]::Error.WriteLine("Error: $Message")
    exit 1
}

try {
    Add-Type -AssemblyName System.Net.Http
}
catch {
    Fail "System.Net.Http is not available in this PowerShell session."
}

function ConvertTo-PlainText {
    param(
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]$SecureString
    )

    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)

    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    }
    finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }
}

function Get-ApiErrorMessage {
    param(
        [AllowEmptyString()]
        [string]$JsonText
    )

    if ([string]::IsNullOrWhiteSpace($JsonText)) {
        return $null
    }

    try {
        $payload = $JsonText | ConvertFrom-Json

        if ($payload.error) {
            return [string]$payload.error
        }

        if ($payload.message) {
            return [string]$payload.message
        }
    }
    catch {
    }

    return $null
}

if (-not $Email) {
    $Email = Read-Host "Email"
}

if (-not $Password) {
    $Password = Read-Host "Password" -AsSecureString
}

$plainPassword = ConvertTo-PlainText -SecureString $Password

if ([string]::IsNullOrWhiteSpace($Email) -or [string]::IsNullOrWhiteSpace($plainPassword)) {
    Fail "Email and password are required."
}

$handler = $null
$client = $null
$content = $null
$responseMessage = $null
$responseBody = $null

try {
    Write-Host "Logging in..."

    $body = @{
        email    = $Email
        password = $plainPassword
    } | ConvertTo-Json -Compress

    $handler = [System.Net.Http.HttpClientHandler]::new()
    $handler.AutomaticDecompression = [System.Net.DecompressionMethods]::GZip -bor [System.Net.DecompressionMethods]::Deflate

    $client = [System.Net.Http.HttpClient]::new($handler)
    $client.DefaultRequestHeaders.Accept.Add([System.Net.Http.Headers.MediaTypeWithQualityHeaderValue]::new("application/json"))
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("okhttp/$OkhttpVersion")
    $client.DefaultRequestHeaders.TryAddWithoutValidation("x-client-version", $SkycardsVersion) | Out-Null

    $content = [System.Net.Http.StringContent]::new($body, [System.Text.Encoding]::UTF8, "application/json")
    $responseMessage = $client.PostAsync("https://api.skycards.oldapes.com/users/", $content).GetAwaiter().GetResult()
    $responseBody = $responseMessage.Content.ReadAsStringAsync().GetAwaiter().GetResult()
}
catch {
    Fail "Failed to connect to the API."
}
finally {
    if ($content) {
        $content.Dispose()
    }

    if ($client) {
        $client.Dispose()
    }

    if ($handler) {
        $handler.Dispose()
    }

    $plainPassword = $null
}

$apiError = Get-ApiErrorMessage -JsonText $responseBody

if (-not $responseMessage.IsSuccessStatusCode) {
    if ($apiError) {
        [Console]::Error.WriteLine("API Error: $apiError")
        exit 1
    }

    Fail "Failed to connect to the API."
}

try {
    $response = $responseBody | ConvertFrom-Json
}
catch {
    [Console]::Error.WriteLine("Error: Failed to parse API response.")
    [Console]::Error.WriteLine("Raw response:")
    [Console]::Error.WriteLine($responseBody)
    exit 1
}

if ($apiError) {
    [Console]::Error.WriteLine("API Error: $apiError")
    exit 1
}

if (-not $response.userData) {
    [Console]::Error.WriteLine("Error: Failed to parse API response.")
    [Console]::Error.WriteLine("Raw response:")
    [Console]::Error.WriteLine($responseBody)
    exit 1
}

$numFleets = 0
if ($null -ne $response.userData.airlines) {
    $numFleets = ($response.userData.airlines | Get-Member -MemberType NoteProperty | Measure-Object).Count
}

$output = [ordered]@{
    skycardsVersion    = $SkycardsVersion
    exportedAt         = [DateTimeOffset]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")
    id                 = $response.userData.id
    name               = $response.userData.name
    xp                 = $response.userData.xp
    cards              = $response.userData.cards
    numAircraftModels  = $response.userData.numAircraftModels
    numDestinations    = $response.userData.numDestinations
    numBattleWins      = $response.userData.numBattleWins
    numAchievements    = $response.userData.numAchievements
    numFleets           = $numFleets
    unlockedAirportIds  = $response.userData.unlockedAirportIds
    completedAirportIds = $response.userData.completedAirportIds
    airlines            = $response.userData.airlines
    uniqueRegs          = $response.userData.uniqueRegs
}

try {
    $json = $output | ConvertTo-Json -Depth 100
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText([System.IO.Path]::GetFullPath($OutputFile), $json, $encoding)
}
catch {
    [Console]::Error.WriteLine("Error: Failed to parse API response.")
    [Console]::Error.WriteLine("Raw response:")
    [Console]::Error.WriteLine($responseBody)
    exit 1
}

Write-Host "Success! User data saved to: $OutputFile"
Write-Host "Upload your JSON file at https://skystats.win/ for a nice pretty dashboard."
