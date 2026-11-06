; Vikey for Windows installer (Inno Setup 6). Per-user, no admin prompt, so the app can update itself.
;   iscc /DVersion=1.0.14 /DArch=x64 /DSrc=..\build\App Vikey.iss
#ifndef Version
  #define Version "0.0.0"
#endif
#ifndef Arch
  #define Arch "x64"
#endif
#ifndef Src
  #define Src "..\build\App"
#endif

[Setup]
AppId={{7E2B5C1A-9D3F-4C7B-8E61-VIKEY0000001}
AppName=HoangKey
AppVersion={#Version}
AppVerName=HoangKey {#Version}
AppPublisher=Hoang
AppPublisherURL=https://vikey.app
AppSupportURL=https://vikey.app/faq
AppUpdatesURL=https://vikey.app/download
VersionInfoVersion={#Version}
DefaultDirName={localappdata}\Programs\HoangKey
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=.\out
OutputBaseFilename=HoangKey-{#Version}-{#Arch}-Setup
SetupIconFile=..\App\Vikey.ico
UninstallDisplayIcon={app}\HoangKey.exe
UninstallDisplayName=HoangKey
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes
CloseApplicationsFilter=HoangKey.exe
RestartApplications=no
#if Arch == "arm64"
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
#else
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#endif

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Messages]
; the few screens people see, in Vietnamese like the app
WelcomeLabel1=Cài đặt HoangKey
WelcomeLabel2=HoangKey {#Version} sẽ được cài cho tài khoản của bạn, không cần quyền quản trị.%n%nBấm Next để tiếp tục.
FinishedHeadingLabel=Đã cài xong HoangKey
FinishedLabel=HoangKey nằm ở khay hệ thống (góc dưới bên phải). Bấm Alt+Z để chuyển Anh/Việt.
ConfirmUninstall=Gỡ HoangKey khỏi máy?

[Files]
Source: "{#Src}\HoangKey.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\HoangKey"; Filename: "{app}\HoangKey.exe"

[Registry]
; the app's own "Mở Vikey khi đăng nhập" entry goes away with the app
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueName: "HoangKey"; Flags: uninsdeletevalue dontcreatekey

[Run]
Filename: "{app}\HoangKey.exe"; Description: "Mở HoangKey"; Flags: nowait postinstall skipifsilent
; a self-update (Vikey runs the installer silently with /RELAUNCH=1) brings the app back
Filename: "{app}\HoangKey.exe"; Flags: nowait; Check: ShouldRelaunch

[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/IM HoangKey.exe /F"; Flags: runhidden; RunOnceId: "KillHoangKey"

[Code]
function ShouldRelaunch: Boolean;
begin
  Result := ExpandConstant('{param:RELAUNCH|0}') = '1';
end;
