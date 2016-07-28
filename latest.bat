:: helper to install
:: latest msi of a gh repo

set USER=%1
set REPO=%2
set ARCH=%3

for %%X in (gh-api-cli.exe) do (set HASGHAPICLI="yes")
if not defined HASGHAPICLI (
  curl -fsSL -o C:\gh-api-cli.msi https://github.com/mh-cbon/gh-api-cli/releases/download/2.0.1/gh-api-cli-amd64.msi
  msiexec.exe /i C:\gh-api-cli.msi /quiet
  set PATH=C:\Program Files\gh-api-cli\;%PATH% # need to set this manually ? ...
)

for %%X in (go-msi.exe) do (set HASGOMSI="yes")
if not defined HASGOMSI (
  gh-api-cli.exe dl-assets -o %USER% -r %REPO% -g "*%ARCH%*msi" --ver latest --out "C:\%REPO%.msi"
  msiexec.exe /i C:\%REPO%.msi /quiet
  set PATH=C:\Program Files\%REPO%\;%PATH% # need to set this manually ? ...
)
