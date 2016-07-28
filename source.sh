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
  if type "wget" > /dev/null; then
    sudo wget -O /etc/apt/sources.list.d/${REPO}.list http://${USER}.github.io/${REPO}/apt/${REPO}.list
  elif type "curl" > /dev/null; then
    sudo curl -L http://${USER}.github.io/${REPO}/apt/${REPO}.list > /etc/apt/sources.list.d/${REPO}.list
  fi
  sudo apt-get update
  sudo apt-get install ${REPO} -y

elif type "dnf" > /dev/null; then
  if type "wget" > /dev/null; then
    sudo wget -O /etc/yum.repos.d/${REPO}.repo http://${USER}.github.io/${REPO}/rpm/${REPO}.repo
  elif type "curl" > /dev/null; then
    sudo curl -L http://${USER}.github.io/${REPO}/rpm/${REPO}.repo > /etc/yum.repos.d/${REPO}.repo
  fi
  sudo dnf update
  sudo dnf install ${REPO} -y

elif type "yum" > /dev/null; then
  if type "wget" > /dev/null; then
    sudo wget -O /etc/yum.repos.d/${REPO}.repo http://${USER}.github.io/${REPO}/rpm/${REPO}.repo
  elif type "curl" > /dev/null; then
    sudo curl -L http://${USER}.github.io/${REPO}/rpm/${REPO}.repo > /etc/yum.repos.d/${REPO}.repo
  fi
  sudo yum update
  sudo yum install ${REPO} -y

fi
