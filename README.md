# latest

Publicly centralized hosted `sh` and `bat` scripts.

## install.sh - Usage

Installs latest `debian` or `rpm` packages hosted on github releases page.

```sh
NAME:
  latest - 0.0.1

USAGE:
  latest

OPTIONS:
  ${GH}               Your user name and repository on github.
  ${ASSET}            The name of the asset to download and process.
                      You can use ${ARCH}, ${VERSION}, ${EXT}, ${REPO}
  ${VERSION}          The version to use, or empty to use latest.

VARIABLES
  ${ARCH}             Is automatically determined from `uname`.
                      Yields a golang compatible value.
                      https://golang.org/doc/install/source#environment
  ${VERSION}          If empty, it is determined from github api.
                      It uses the tag_name of the release.
  ${EXT}              It is detected from the system capabilities.
                      If the system runs 'dpkg' => '.deb'
                      If the system runs 'dnf' => '.rpm'
                      If the system runs 'yum' => '.rpm'
  ${REPO}             It is detected from your input.
                      Given 'mh-cbon/tomate' => 'tomate'
```

### Using curl

```sh
curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/install.sh \
| GH=mh-cbon/go-bin-deb ASSET='${REPO}-${ARCH}${EXT}' sh -xe
```

### Using wget

```sh
wget -q -O - --no-check-certificate \
https://raw.githubusercontent.com/mh-cbon/latest/master/install.sh \
| GH=mh-cbon/go-bin-deb ASSET='${REPO}-${ARCH}${EXT}' VERSION='x.x.x' sh -xe
```

## source.sh - Usage

Installs a source `debian` or `rpm` repository hosted on `gh-pages`

```sh
NAME:
  source - 0.0.1

USAGE:
  latest

OPTIONS:
  ${GH}               Your user name and repository on github.
```

### Using curl

```sh
curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/source.sh \
| GH=mh-cbon/go-bin-deb sh -xe
```

### Using wget

```sh
wget -q -O - --no-check-certificate \
https://raw.githubusercontent.com/mh-cbon/latest/master/source.sh \
| GH=mh-cbon/go-bin-deb sh -xe
```

## latest.bat - Usage

Installs latest `msi` packages hosted on github releases page.

```sh
NAME:
  latest - 0.0.1

USAGE:
  latest <USER> <REPO> <ARCH>

OPTIONS:
  ${USER}             Your Github user name.
  ${REPO}             Your Github repository name.
  ${ARCH}             Architecture of the target system.
```

### Using curl

```sh
curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/latest.bat
cmd /C latest.bat mh-cbon gh-api-cli amd64
```
