#!/usr/bin/env bash
# Only needed if switching to the non portable
# ln -f -s /lib64/libncurses.so.6.1 libtinfo.so.5
# ln -f -s $HOME/pypy/bin/pypy $HOME/bin/python
set -x
PYPY_LOGFILE=$HOME/.ansible/pypy.log
exec  >> $PYPY_LOGFILE 2>&1

echo "Checking PYPY from binary"
$HOME/.ansible/pypy/bin/pypy --version

echo "Checking PYPY from binary"
$HOME/bin/python --version

echo "Installing  pip"
$HOME/.ansible/pypy/bin/pypy -m ensurepip

echo "Checking PIP3 from binary"
$HOME/.ansible/pypy/bin/pip3 --version

echo "Checking easy_install3 from binary"
$HOME/.ansible/.pypy/bin/easy_install-3.5 --version

ln -f -s $HOME/.ansible/pypy/bin/pip3 $HOME/bin/pip
ln -f -s $HOME/.ansible/pypy/bin/easy_install-3.5 $HOME/bin/easy_install

echo "Validating symlinked python commands"
$HOME/pypy/bin/pypy --version
$HOME/pypy/bin/pip --version
$HOME/pypy/bin/easy_install --version
