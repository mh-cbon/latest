#!/bin/sh -x -e

GH=$1
ASSET=$2
VERSION=$3

# find current system arch
ARCH=$(uname -m)
case $ARCH in
	arm*) ARCH="arm";;
	x86) ARCH="386";;
	x86_64) ARCH="amd64";;
esac

# determine repository name
REPO=`echo $GH | cut -d '/' -f 2`

# determine version to dl
if [ "${VERSION}" == "" ];then
  # find the latest tag
  if type "wget" > /dev/null; then
    LATEST=`wget -q --no-check-certificate -O - https://api.github.com/repos/${GH}/releases/latest`
  else if type "curl" > /dev/null; then
    LATEST=`curl https://api.github.com/repos/${GH}/releases/latest`
  fi
  LATEST=`echo "${LATEST}" | grep -E '"tag_name": "([^"]+)"' | cut -d '"' -f4`
  VERSION=`echo ${LATEST}`
fi

# determine the underlying system packager
EXT=""
if type "dpkg" > /dev/null; then
  EXT=".deb"
fi
if type "dnf" > /dev/null; then
  EXT=".rpm"
fi
if type "yum" > /dev/null; then
  EXT=".rpm"
fi

# find the name of the asset
ASSET=`eval echo ${ASSET}`

# forge the dl url
URL="https://github.com/${GH}/releases/download/${VERSION}/${ASSET}"

# clean asset.
if [ -f "${ASSET}" ]; then
  rm -f ${ASSET}
fi

# dl the asset
if type "wget" > /dev/null; then
  wget -O ${ASSET} --no-check-certificate ${URL}
else if type "curl" > /dev/null; then
  curl -o ${ASSET} ${URL}
fi

# is it a debian package ?
if [[ "${ASSET}" == *".deb" ]]; then
  # echo "it s a deb!"
  sudo dpkg -i ${ASSET}
  sudo apt-get install --fix-missing
fi

# is it an rpm package ?
if [[ "${ASSET}" == *".rpm" ]]; then
  # echo "it s an rpm!"
  # does the system run yum or dnf ?
  if type "dnf" > /dev/null; then
    sudo dnf install ${ASSET} -y
  fi
  if type "yum" > /dev/null; then
    sudo yum install ${ASSET} -y
  fi
fi