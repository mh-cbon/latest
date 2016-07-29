:: helper to install
:: latest msi of a gh repo

set USER=%1
set REPO=%2
set ARCH=%3

gh-api-cli.exe --version >nul 2>&1 && (
    echo found gh-api-cli
) || (
  echo "downloading"
  curl -fsSL -o C:\gh-api-cli.msi https://github.com/mh-cbon/gh-api-cli/releases/download/3.0.0/gh-api-cli-amd64.msi
  echo "installing"
  msiexec.exe /i C:\gh-api-cli.msi /quiet
  echo "saving path"
);

go-msi.exe --version >nul 2>&1 && (
    echo found go-msi
) || (
  echo "downloading"
  echo "C:\Program Files\gh-api-cli\gh-api-cli.exe dl-assets -t "GHTOKEN" -o %USER% -r %REPO% -g "*%ARCH%*msi" --ver latest --out "C:\%REPO%.msi" --skip-prerelease=yes"
  echo off
  "C:\Program Files\gh-api-cli\gh-api-cli.exe" dl-assets -t "%GHTOKEN%" -o %USER% -r %REPO% -g "*%ARCH%*msi" --ver latest --out "C:\%REPO%.msi" --skip-prerelease=yes
  echo on
  dir *.msi
  echo "installing"
  msiexec.exe /i C:\%REPO%.msi /quiet
  echo "saving path"
)
