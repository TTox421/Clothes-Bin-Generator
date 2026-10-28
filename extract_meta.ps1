param(
    [Parameter(Mandatory=$true)]
    [string]$GtaPath,
    [Parameter(Mandatory=$true)]
    [string]$CwDll,
    [Parameter(Mandatory=$true)]
    [string]$OutputDir
)

$ErrorActionPreference = "Stop"

try {
    # 1. Load CodeWalker.Core.dll safely
    [System.Reflection.Assembly]::LoadFrom($CwDll) | Out-Null
    [CodeWalker.GameFiles.GTA5Keys]::LoadFromPath($GtaPath)

    # 2. Extract dlclist.xml from update.rpf
    $updateRpfPath = Join-Path $GtaPath "update\update.rpf"
    if (-not (Test-Path $updateRpfPath)) {
        throw "update.rpf not found at: $updateRpfPath"
    }

    $updateRpf = New-Object CodeWalker.GameFiles.RpfFile($updateRpfPath, $updateRpfPath)
    $updateRpf.ScanStructure([Action[string]]{}, [Action[string]]{})
    $dlcListEntry = $updateRpf.AllEntries | Where-Object { $_.Name -eq "dlclist.xml" }
    if (-not $dlcListEntry) {
        throw "dlclist.xml not found inside update.rpf"
    }

    $dlcListBytes = $updateRpf.ExtractFile($dlcListEntry)
    $dlcListXml = [System.Text.Encoding]::UTF8.GetString($dlcListBytes)

    if (Test-Path $OutputDir) {
        Remove-Item -Recurse -Force $OutputDir -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

    [xml]$doc = $dlcListXml
    $rawPaths = $doc.SMandatoryPacksData.Paths.Item
    $dlcList = @()

    foreach ($p in $rawPaths) {
        $cleanP = $p.Trim().TrimEnd('/')
        $packName = $cleanP.Split('/')[-1]
        
        # Strictly skip any g9ec packs
        if ($packName -like "*g9ec*") {
            continue
        }
        $dlcList += $packName
    }

    $metaList = @()

    foreach ($packName in $dlcList) {
        $candidate1 = Join-Path $GtaPath "update\x64\dlcpacks\$packName\dlc.rpf"
        $candidate2 = Join-Path $GtaPath "x64\dlcpacks\$packName\dlc.rpf"
        $rpfPath = $null
        if (Test-Path $candidate1) { $rpfPath = $candidate1 }
        elseif (Test-Path $candidate2) { $rpfPath = $candidate2 }

        if (-not $rpfPath) {
            continue
        }

        try {
            $r = New-Object CodeWalker.GameFiles.RpfFile($rpfPath, $rpfPath)
            $r.ScanStructure([Action[string]]{}, [Action[string]]{})
            $entries = $r.AllEntries | Where-Object {
                $_.Name -like "mp_m_freemode_01_*shop.meta" -or
                $_.Name -like "mp_f_freemode_01_*shop.meta" -or
                $_.Name -like "*_shop.meta"
            }

            if ($entries) {
                $packDir = Join-Path $OutputDir $packName
                New-Item -ItemType Directory -Path $packDir -Force | Out-Null

                foreach ($e in $entries) {
                    $bytes = $r.ExtractFile($e)
                    $outPath = Join-Path $packDir $e.Name
                    [System.IO.File]::WriteAllBytes($outPath, $bytes)
                    $metaList += [PSCustomObject]@{
                        Pack = $packName
                        FileName = $e.Name
                        Path = $outPath
                    }
                }
            }
        } catch {
            Write-Warning ("Could not read {0}: {1}" -f $rpfPath, $_.Exception.Message)
        }
    }

    $result = [PSCustomObject]@{
        Status = "OK"
        DlcOrder = $dlcList
        ShopMetas = $metaList
    }

    $jsonOutput = $result | ConvertTo-Json -Depth 5
    $jsonPath = Join-Path $OutputDir "scan_result.json"
    [System.IO.File]::WriteAllText($jsonPath, $jsonOutput, [System.Text.Encoding]::UTF8)

    Write-Host "SCAN_SUCCESS:$jsonPath"
} catch {
    Write-Error $_
    exit 1
}
