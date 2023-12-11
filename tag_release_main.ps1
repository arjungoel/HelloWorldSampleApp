New-Item -ItemType File -Path .\release.txt
git fetch --tags
$lastTagObj = git tag --sort=-creatordate | Where-Object { $_ -match 'v1\.\d+\.\d+-[A-Za-z0-9]+' } | Sort-Object | Select-Object -Last 1
Write-Host "lastTagObj: $lastTagObj"
$lastTag = "$lastTagObj"
Write-Host "lastTag: $lastTag"
$lengthOfTag = $lastTag.Length
Write-Host "lengthOfTag: $lengthOfTag"
$sIndex = $lastTag.IndexOf("v") + 1
$eIndex = $lastTag.IndexOf("-") - 1
Write-Host "sIndex: $sIndex, eIndex: $eIndex"
$tagVersion = $lastTag.SubString($sIndex, $eIndex - $sIndex + 1)
Write-Host "tagVersion: $tagVersion" 

$numericTagVersion = $tagVersion -split '\.' -join ''
Write-Host "numbericTagVersion: $numericTagVersion" 
$nextNumericTagVersion = [int]$numericTagVersion + 1
Write-Host "nextNumericTagVersion: $nextNumericTagVersion"
$finalTagVersion = $nextNumericTagVersion -replace '(\d)(?=(\d{1,2})+$)', '$1.'
Write-Host "finalTagVersion: $finalTagVersion"
$finalTagVersionName = "v" + $finalTagVersion + "-develop"
Write-Host "finalTagVersionName: $finalTagVersionName"
$finalTagVersionName | Out-File -FilePath "release.txt" -Encoding UTF8

git tag -a $finalTagVersionName -m "New release version"
git push origin $finalTagVersionName
Write-Host "$finalTagVersionName is created successfully"