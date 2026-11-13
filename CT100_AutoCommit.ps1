Set-Location "$HOME\Documents\current_sensor"

$files = @(
    "current_sensor.kicad_sch",
    "current_sensor.kicad_pcb",
    "current_sensor.kicad_pro",
    "CT100_custom.kicad_sym",
    "sym-lib-table"
)

Write-Host "CT100 AutoCommit is running!"
Write-Host "Save in KiCad to create Git commits."
Write-Host "Press Ctrl+C to stop."

while ($true) {
    $before = (git status --porcelain -- $files) -join "`n"

    if ($before) {
        Start-Sleep -Seconds 4

        $after = (git status --porcelain -- $files) -join "`n"

        if ($before -eq $after) {
            git add -- $files

            if ($LASTEXITCODE -eq 0) {
                git diff --cached --quiet

                if ($LASTEXITCODE -eq 1) {
                    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    git commit -m "KiCad autosave $stamp"
                }
            }
        }
    }

    Start-Sleep -Seconds 5
}
