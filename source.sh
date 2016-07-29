#!/bin/sh -e

# this is an helper
# to install a source repo
# hosted on gh-pages
#
# to use it
# curl -L https://raw.githubusercontent.com/mh-cbon/latest/master/source.sh \
# | GH=mh-cbon/gh-api-cli sh -xe

# GH=$1

REPO=`echo ${GH} | cut -d '/' -f 2`
USER=`echo ${GH} | cut -d '/' -f 1`

if type "dpkg" > /dev/null; then
  
  FILE=/etc/apt/sources.list.d/${REPO}.list
  URL=http://${USER}.github.io/${REPO}/apt/${REPO}.list

  if type "wget" > /dev/null; then
    sudo rm -f ${FILE}
    sudo wget -O ${FILE} ${URL}
  elif type "curl" > /dev/null; then
    sudo curl -L ${URL} > ${FILE}
  fi
  sudo apt-get update
  sudo apt-get install ${REPO} -y

elif type "dnf" > /dev/null; then

  FILE=/etc/yum.repos.d/${REPO}.repo
  URL=http://${USER}.github.io/${REPO}/rpm/${REPO}.repo

  if type "wget" > /dev/null; then
    sudo rm -f ${FILE}
    sudo wget -O ${FILE} ${URL}
  elif type "curl" > /dev/null; then
    sudo curl -L ${URL} > ${FILE}
  fi
  sudo dnf install ${REPO} -y

elif type "yum" > /dev/null; then

  FILE=/etc/yum.repos.d/${REPO}.repo
  URL=http://${USER}.github.io/${REPO}/rpm/${REPO}.repo

  if type "wget" > /dev/null; then
    sudo rm -f ${FILE}
    sudo wget -O ${FILE} ${URL}
  elif type "curl" > /dev/null; then
    sudo curl -L ${URL} > ${FILE}
  fi
  sudo yum install ${REPO} -y

fi
