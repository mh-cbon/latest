# latest

A centralized and publicly hosted `sh` script to install latest `debian`
or `rpm` package from a github repository.

# Usage

```sh
NAME:
  latest - 0.0.1

USAGE:
  latest
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

## Using curl

```sh
curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/install.sh \
| GH=mh-cbon/go-bin-deb ASSET='${REPO}-${ARCH}${EXT}' sh -xe
```

## Using wget

```sh
wget -q -O - --no-check-certificate \
https://raw.githubusercontent.com/mh-cbon/latest/master/install.sh \
| GH=mh-cbon/go-bin-deb ASSET='${REPO}-${ARCH}${EXT}' VERSION='x.x.x' sh -xe
```
