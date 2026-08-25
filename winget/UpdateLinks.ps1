$packages = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages"
$links    = "$env:LOCALAPPDATA\Microsoft\WinGet\Links"
New-Item -ItemType Directory -Path $links -Force | Out-Null

$exe = Get-ChildItem $packages -Directory | ForEach-Object {
    $package = $_
    $dirs = @($package)
    $dirs += Get-ChildItem $package.FullName -Directory
    $dirs += Get-ChildItem $package.FullName -Directory -Recurse |
        Where-Object Name -IEQ 'bin'

    $dirs.FullName | Sort-Object -Unique | ForEach-Object {
        Get-ChildItem $_ -File -Filter '*.exe' -ErrorAction SilentlyContinue
    }
}

$exe | Sort-Object FullName -Unique | Group-Object Name | ForEach-Object {
    if ($_.Count -gt 1) {
        Write-Error "Несколько вариантов $($_.Name): $($_.Group.FullName -join ', ')"
        return
    }

    $target = $_.Group[0].FullName
    $link   = Join-Path $links $_.Name
    $old    = Get-Item $link -Force -ErrorAction SilentlyContinue

    if ($old) {
        $oldTarget = @($old.Target) | ForEach-Object {
            if ([IO.Path]::IsPathRooted($_)) { [IO.Path]::GetFullPath($_) }
            else { [IO.Path]::GetFullPath((Join-Path $links $_)) }
        }

        if ($target -in $oldTarget) {
            Write-Host "OK: $($_.Name)"
        } else {
            Write-Error "Конфликт $link -> $($old.Target); ожидалось -> $target"
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $link -Target $target | Out-Null
        Write-Host "Создано: $($_.Name) -> $target"
    }
}
