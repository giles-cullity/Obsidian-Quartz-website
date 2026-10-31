$src  = "C:\Users\giles\complete vault\public"
$dest = "C:\Users\giles\quartz\content"

if (-not (Test-Path $src)) { throw "Source missing: $src" }

# Mirror the vault folder into content (deletes stale files in content only)
robocopy $src $dest /MIR /XD ".obsidian" ".git" /XF desktop.ini /NFL /NDL /NJH /NJS /NP
if ($LASTEXITCODE -ge 8) { throw "robocopy failed ($LASTEXITCODE)" }

# Strip the "public/" prefix from canvas file paths, in the copy only
$utf8 = New-Object Text.UTF8Encoding($false)
Get-ChildItem $dest -Recurse -Filter *.canvas | ForEach-Object {
    $t = [IO.File]::ReadAllText($_.FullName)
    $n = $t -replace '("file"\s*:\s*")public/', '$1'
    if ($n -ne $t) { [IO.File]::WriteAllText($_.FullName, $n, $utf8) }
}
Write-Host "Synced."