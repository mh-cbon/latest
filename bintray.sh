#!/bin/sh -e

# this is an helper
# to install a source repo
# hosted on bintray
#
# to use it
# curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/bintray.sh \
# | GH=USER/REPO sh -xe
#
# for debian, some more arguments are available
# curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/bintray.sh \
# | GH=USER/REPO DISTRIB=... COMPONENT=... sh -xe

# GH=$1
# DISTRIB=$2
# COMPONENT=$3

if [ -z "$GH" ]; then
    echo "wrong command line, must pass GH=user/repo"
fi

if [ -z "$DISTRIB" ]; then
    DISTRIB="unstable"
fi

if [ -z "$COMPONENT" ]; then
    COMPONENT="main"
fi

REPO=`echo ${GH} | cut -d '/' -f 2`
USER=`echo ${GH} | cut -d '/' -f 1`

DLCMD=""
DLArgs=""
FILE=""
URL=""

if type "dpkg" > /dev/null; then

  echo "deb https://dl.bintray.com/${USER}/deb ${DISTRIB} ${COMPONENT}" | sudo tee -a /etc/apt/sources.list

  if type "sudo" > /dev/null; then
    sudo apt-get install apt-transport-https software-properties-common -y --quiet
    sudo apt-get update --quiet
    sudo apt-get install ${REPO} -y --quiet --allow-unauthenticated
  else
    apt-get install apt-transport-https software-properties-common -y --quiet
    apt-get update --quiet
    apt-get install ${REPO} -y --quiet --allow-unauthenticated
  fi

elif type "dnf" > /dev/null; then

  FILE=/etc/yum.repos.d/${USER}.repo
  URL=https://bintray.com/${USER}/rpm/rpm/${REPO}.repo

  if type "wget" > /dev/null; then
    DLCMD='wget -q -O '
    DLArgs="${FILE} ${URL}"
  elif type "curl" > /dev/null; then
    DLCMD='curl -s -L'
    DLArgs="${URL} > ${FILE}"
  fi

  if type "sudo" > /dev/null; then
    sudo /bin/sh -c "${DLCMD} ${DLArgs}"
  else
    $DLCMD ${DLArgs}
  fi

  if type "sudo" > /dev/null; then
    sudo dnf install ${REPO} -y --quiet
  else
    dnf install ${REPO} -y --quiet
  fi

elif type "yum" > /dev/null; then

  FILE=/etc/yum.repos.d/${USER}.repo
  URL=https://bintray.com/${USER}/rpm/rpm/${REPO}.repo

  if type "wget" > /dev/null; then
    DLCMD='wget -q -O '
    DLArgs="${FILE} ${URL}"
  elif type "curl" > /dev/null; then
    DLCMD='curl -s -L'
    DLArgs="${URL} > ${FILE}"
  fi

  if type "sudo" > /dev/null; then
    sudo /bin/sh -c "${DLCMD} ${DLArgs}"
  else
    $DLCMD ${DLArgs}
  fi

  if type "sudo" > /dev/null; then
    sudo yum install ${REPO} -y --quiet
  else
    yum install ${REPO} -y --quiet
  fi

fi
