$ErrorActionPreference = 'Stop'
$env:PATH = "C:\Users\ADMIN\llvm-mingw\llvm-mingw-20261020-ucrt-x86_64\bin;" + $env:PATH
$root = "C:\Users\ADMIN\Documents\HoangKey"
Set-Location $root

Write-Host "==> Compiling resources..."
windres -I "$root/Windows/App" -I "$root/Engine" "$root/Windows/App/Vikey.rc" -O coff -o "$root/Windows/App/Vikey.res"

$cflags = @(
    "-c", "-O2", "-std=c++17",
    "-DUNICODE", "-D_UNICODE", "-D_WIN32_WINNT=0x0A00",
    "-fms-extensions", "-Wno-deprecated-declarations",
    "-I", "$root/Engine", "-I", "$root/Engine/platforms", "-I", "$root/Windows/App"
)

Write-Host "==> Compiling Engine..."
clang++ @cflags "$root/Engine/Engine.cpp" -o "$root/Engine/Engine.o"
clang++ @cflags "$root/Engine/Vietnamese.cpp" -o "$root/Engine/Vietnamese.o"
clang++ @cflags "$root/Engine/SmartSwitchKey.cpp" -o "$root/Engine/SmartSwitchKey.o"
clang++ @cflags "$root/Engine/Driver.cpp" -o "$root/Engine/Driver.o"
clang++ @cflags "$root/Engine/TouchModel.cpp" -o "$root/Engine/TouchModel.o"

Write-Host "==> Compiling Windows App..."
clang++ @cflags "$root/Windows/App/main.cpp" -o "$root/Windows/App/main.o"
clang++ @cflags "$root/Windows/App/Core.cpp" -o "$root/Windows/App/Core.o"
clang++ @cflags "$root/Windows/App/Prefs.cpp" -o "$root/Windows/App/Prefs.o"
clang++ @cflags "$root/Windows/App/Site.cpp" -o "$root/Windows/App/Site.o"
clang++ @cflags "$root/Windows/App/Settings.cpp" -o "$root/Windows/App/Settings.o"
clang++ @cflags "$root/Windows/App/Emoji.cpp" -o "$root/Windows/App/Emoji.o"
clang++ @cflags "$root/Windows/App/Updater.cpp" -o "$root/Windows/App/Updater.o"
clang++ @cflags "$root/Windows/App/CrashReporter.cpp" -o "$root/Windows/App/CrashReporter.o"

Write-Host "==> Compiling tweetnacl (C)..."
clang -c -O2 -w "$root/Windows/App/third_party/tweetnacl.c" -o "$root/Windows/App/third_party/tweetnacl.o"

Write-Host "==> Linking HoangKey.exe..."
$objs = @(
    "$root/Engine/Engine.o",
    "$root/Engine/Vietnamese.o",
    "$root/Engine/SmartSwitchKey.o",
    "$root/Engine/Driver.o",
    "$root/Engine/TouchModel.o",
    "$root/Windows/App/main.o",
    "$root/Windows/App/Core.o",
    "$root/Windows/App/Prefs.o",
    "$root/Windows/App/Site.o",
    "$root/Windows/App/Settings.o",
    "$root/Windows/App/Emoji.o",
    "$root/Windows/App/Updater.o",
    "$root/Windows/App/CrashReporter.o",
    "$root/Windows/App/third_party/tweetnacl.o",
    "$root/Windows/App/Vikey.res"
)

$libs = @(
    "-luser32", "-lshell32", "-lgdi32", "-ladvapi32", "-limm32", "-lpsapi",
    "-lole32", "-loleaut32", "-lcomctl32", "-lgdiplus", "-lwinhttp", "-lwinmm",
    "-ld2d1", "-ldwrite", "-ldwmapi", "-lnormaliz", "-luiautomationcore", "-luuid"
)

clang++ -O2 -mwindows -municode $objs $libs -o "$root/bin/HoangKey.exe"

if (Test-Path "$root/bin/HoangKey.exe") {
    $info = Get-Item "$root/bin/HoangKey.exe"
    Write-Host "SUCCESS! Built $($info.FullName) ($($info.Length) bytes, $($info.LastWriteTime))"
} else {
    Write-Error "Build failed!"
}
