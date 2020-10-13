#!/usr/bin/env bash

# ==============================================================================
# DEFINE CONSTANTS
# ==============================================================================

# Check OS
if [[ "${OSTYPE}" != "darwin"* ]]; then
  echo "This script only support MacOS system."
  exit 1
fi

ROOT_PATH=`dirname "$BASH_SOURCE"`/..
HOME_DIR=${HOME}
PACKAGE_MANAGER=brew

ANACONDA=https://repo.anaconda.com/archive/Anaconda3-2019.03-MacOSX-x86_64.sh
ANACONDA_SH_FILE=Anaconda3-2019.03-MacOSX-x86_64.sh


# ==============================================================================
# INSTALL ESSENTIAL THINGS
# ==============================================================================

# install anaconda
echo "Downloading Anaconda..."
wget ${ANACONDA}
# wait
echo "Installing Anaconda..."
bash ./${ANACONDA_SH_FILE}

# Install AG
echo "Installing AG"
$PACKAGE_MANAGER install the_silver_searcher


# ==============================================================================
# CONFIGS
# ==============================================================================

# Config vim
# Thanks to https://github.com/JDevlieghere/dotfiles/blob/master/.vim/.ycm_extra_conf.py
echo "Configuring VIM"
ln -s ${ROOT_PATH}/vim/vimrc ${HOME_DIR}/.vimrc \
  && mkdir ~/.vim && ln -s ${ROOT_PATH}/vim/ycm_extra_conf.py ${HOME_DIR}/.vim/.ycm_extra_conf.py \
  && vim +PlugInstall +qall \
  && cd ~/.vim/bundle/YouCompleteMe \
  && /usr/bin/python install.py --clang-completer && cd ${ROOT_PATH}
