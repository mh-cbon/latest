:: helper to install
:: latest msi of a gh repo

set USER=%1
set REPO=%2
set ARCH=%3

gh-api-cli.exe --version
if (%ERRORLEVEL% > 0) then (
  curl -fsSL -o C:\gh-api-cli.msi https://github.com/mh-cbon/gh-api-cli/releases/download/2.0.1/gh-api-cli-amd64.msi
  msiexec.exe /i C:\gh-api-cli.msi /quiet
  set PATH=C:\Program Files\gh-api-cli\;%PATH%
)

go-msi.exe --version
if (%ERRORLEVEL% > 0) then (
  gh-api-cli.exe dl-assets -o %USER% -r %REPO% -g "*%ARCH%*msi" --ver latest --out "C:\%REPO%.msi"
  msiexec.exe /i C:\%REPO%.msi /quiet
  set PATH=C:\Program Files\%REPO%\;%PATH%
)
