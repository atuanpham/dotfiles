#!/usr/bin/env bash

# Check OS
if [[ "${OSTYPE}" != "darwin"* ]]; then
  echo "This script only support MacOS system."
  exit 1
fi

HOME_DIR=${HOME}
PACKAGE_MANAGER=brew

ANACONDA_DOWNLOAD_LINK=https://repo.anaconda.com/archive/Anaconda3-2019.10-MacOSX-x86_64.sh
ANACONDA_SH_FILE=Anaconda3.sh

JAVA_DOWNLOAD_LINK=https://cdn.azul.com/zulu/bin/zulu13.29.9-ca-jdk13.0.2-macosx_x64.dmg
