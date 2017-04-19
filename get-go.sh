#!/bin/sh -e

set -e
set -x

# install go, specific to vagrant
if type "go" > /dev/null; then
  echo "go already installed"

else

  oldpwd=`pwd`

  if ["${GOINSTALL}" = ""]; then
    GOINSTALL="/go"
    echo "GOINSTALL set to ${GOINSTALL}"
  fi

  sudo mkdir -p ${GOINSTALL}
  [ -d "/home/vagrant" ] && sudo chown -R vagrant:vagrant -R ${GOINSTALL}

  cd ${GOINSTALL}

file="go1.8.1.linux-amd64.tar.gz"

  if type "wget" > /dev/null; then
    [ -f "${file}" ] || wget https://storage.googleapis.com/golang/${file}
  fi
  if type "curl" > /dev/null; then
    [ -f "${file}" ] || curl -o ${file} https://storage.googleapis.com/golang/${file}
  fi
  [ -d "go" ] || tar -xf ${file}
  [ -f "${file}" ] && rm ${file}

  ls -al ${GOINSTALL}
  ls -al ${GOINSTALL}/bin

  export GOROOT=/go/go/
  export PATH=$PATH:$GOROOT/bin

  cd $oldpwd

fi