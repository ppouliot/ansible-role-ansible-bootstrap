#!/usr/bin/env bash
set -x

# Set PYTHON 3 Binary Name
PYPY_PORTABLE_VERSION='pypy3.5-6.0.0-linux_x86_64-portable'

echo "Testing for .ansible"
if [ ! -d $HOME/.ansible ];
then
  echo "Creating folder structure for bootstrapping ansible on Container-Linux Platforms"
  mkdir -p $HOME/.ansible
  mkdir -p $HOME/.ansible/logs
  mkdir -p $HOME/.ansible/tmp
  mkdir -p $HOME/bin
fi

BOOTSTRAP_LOGFILE=$HOME/.ansible/logs/bootstrap.log
exec >> $BOOTSTRAP_LOGFILE 2>&1


echo "Creating folders and downloading pypy binaries"
cd $HOME/.ansible/tmp
echo "Downloading PYPY Portable binary: $PYPY_PORTABLE_VERSION" 
wget -nv https://bitbucket.org/squeaky/portable-pypy/downloads/$PYPY_PORTABLE_VERSION.tar.bz2 ;
cd $HOME/.ansible


echo "Extracting PYPY Portable binary: $PYPY_PORTABLE_VERSION" 
cd $HOME/.ansible
tar -xjf tmp/$PYPY_PORTABLE_VERSION.tar.bz2

echo "Renaming $PYPY_PORTABLE_VERSION to pypy" 
mv $PYPY_PORTABLE_VERSION pypy

echo "Removing downloaded PYPY Portable binary file $PYPY_PORTABLE_VERSION.tar.bz2" 
rm -rf tmp/$PYPY_PORTABLE_VERSION.tar.bz2

echo "Setting resursive permissions on pypy directory." 
chmod -R ugo+x $HOME/.ansible/pypy

echo "Creating a symlink for easy use of python." 
ln -f -s $HOME/.ansible/pypy/bin/pypy $HOME/bin/python

echo "Validating symlinked python commands"
$HOME/bin/python --version
