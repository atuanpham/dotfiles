#!/usr/bin/env bash

# install anaconda
echo "Downloading Anaconda..."
wget -P ${HOME}/Downloads/${ANACONDA_SH_FILE} ${ANACONDA_DOWNLOAD_LINK}
# wait
echo "Installing Anaconda..."
bash ${HOME}/Downloads/${ANACONDA_SH_FILE}

# Install AG
echo "Installing AG..."
$PACKAGE_MANAGER install the_silver_searcher

# Install NNN
echo "Installing NNN..."
$PACKAGE_MANAGER install nnn

# Install Java

