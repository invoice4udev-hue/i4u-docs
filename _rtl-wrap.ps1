$rle = [string][char]0x202B
$pdf = [string][char]0x202C
$enc = New-Object System.Text.UTF8Encoding($false)
$count = 0

$reList = New-Object regex '^(\s*(?:[*+-]|\d+\.)\s+)\u200F?(.*[\u0590-\u05FF].*)$'
$reHead = New-Object regex '^(#{1,6}\s+)\u200F?(.*?[\u0590-\u05FF].*?)(\s*\{#[\w-]+\})?$'
$rePara = New-Object regex '^\u200F?(.*[\u0590-\u05FF].*)$'
$reCell = New-Object regex '(\|\s*)\u200F?((?:\\\||[^|])+?)(?=\s*\|)'
$heb    = New-Object regex '[\u0590-\u05FF]'

$cellEval = [System.Text.RegularExpressions.MatchEvaluator]{
    param($m)
    $content = $m.Groups[2].Value
    if ($heb.IsMatch($content) -and -not $content.Contains([char]0x202B)) {
        return $m.Groups[1].Value + $rle + $content + $pdf
    }
    return $m.Value
}

Get-ChildItem 'C:\Invoice4u\i4u-docs\he' -Recurse -Filter *.md | Where-Object { $_.Name -ne 'SUMMARY.md' } | ForEach-Object {
    $lines = [System.IO.File]::ReadAllLines($_.FullName)
    $in = $false
    $changed = $false
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $l = $lines[$i]
        if ($l -match '^\s*```') { $in = -not $in; continue }
        if ($in -or $l.Length -eq 0) { continue }
        if ($l.Contains([char]0x202B)) { continue }   # already wrapped
        if ($l.StartsWith('{%') -or $l.StartsWith('$$')) { continue }
        $new = $l
        $m = $reList.Match($l)
        if ($m.Success) {
            $new = $m.Groups[1].Value + $rle + $m.Groups[2].Value + $pdf
        }
        elseif (($m = $reHead.Match($l)).Success) {
            $new = $m.Groups[1].Value + $rle + $m.Groups[2].Value + $pdf + $m.Groups[3].Value
        }
        elseif ($l.StartsWith('|')) {
            $new = $reCell.Replace($l, $cellEval)
        }
        elseif (($m = $rePara.Match($l)).Success) {
            $new = $rle + $m.Groups[1].Value + $pdf
        }
        if (-not [string]::Equals($new, $l, [System.StringComparison]::Ordinal)) {
            $lines[$i] = $new
            $changed = $true
        }
    }
    if ($changed) {
        [System.IO.File]::WriteAllLines($_.FullName, $lines, $enc)
        $count++
        Write-Output ("changed: " + $_.FullName.Replace('C:\Invoice4u\i4u-docs\he\',''))
    }
}
Write-Output "total: $count"
