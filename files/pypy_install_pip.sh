#!/usr/bin/env bash

PYPY_INSTALL_PIP_LOGFILE=$HOME/.ansible/logs/pypy_install_pip.log
exec >> $PYPY_INSTALL_PIP_LOGFILE 2>&1

echo "Validating symlinked python command"
$HOME/bin/python --version

echo "Installing pip"
$HOME/.ansible/pypy/bin/pypy -m ensurepip ;

echo "Checking PIP3 from binary"
$HOME/.ansible/pypy/bin/pip3 --version

echo "Upgrading pip to the latest version from binary"
$HOME/.ansible/pypy/bin/pip3 install --upgrade pip

echo "Checking new version"
$HOME/.ansible/pypy/bin/pip3 --version

echo "Checking easy_install3 from binary"
$HOME/.ansible/.pypy/bin/easy_install-3.5 --version

echo "Creating remainaing symlinks"
ln -f -s $HOME/.ansible/pypy/bin/pip3 $HOME/bin/pip
ln -f -s $HOME/.ansible/pypy/bin/easy_install-3.5 $HOME/bin/easy_install

echo "Validating symlinked pip and easy_install commands"
$HOME/bin/pip --version
$HOME/bin/easy_install --version
