#!/usr/bin/env bash

# Set PYTHON 3 Stable Portable Binary Name
PYPY_PORTABLE_VERSION='pypy3.6-7.1.1-linux_x86_64-portable'

echo "Testing for .ansible for bootstrap operations
if [ ! -d $HOME/.ansible ];
then
  echo "Creating folder structure for ansible operations"
  mkdir -p $HOME/.ansible
  mkdir -p $HOME/.ansible/logs
  mkdir -p $HOME/.ansible/tmp
fi

echo "Testing for $HOME/bin"
if [ ! -d $HOME/bin ];
then
  echo "Creating $HOME/bin for local applications"
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

echo "Adding HOME/bin to path"
if [ ! -e $HOME/.bash_profile ];
then
  cat <<EOF > $HOME/.bash_profile
export PATH=${HOME}/bin:$PATH
EOF
fi 
