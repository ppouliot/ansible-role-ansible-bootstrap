#!/usr/bin/env bash

PYTHON_VERSION="3.6"
# PYPY 7.3.1 has an issue with linked libries on MacOS
PYPY_VERSION="7.3.3"
UNAME=`which uname`
CURL=`which curl`
WGET=`which wget`
ARCH=`${UNAME} -m`

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
  if [[ ${ARCH} == "x86_64" ]]; then
    PYPY_ARCH="linux64"
  elif [[ ${ARCH} == "aarch64" ]]; then
    PYPY_ARCH=${ARCH}
  else
    echo "Unsupported Linux Architecture!"
    exit
  fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
  OS="macos"
  if [[ ${ARCH} == "x86_64" ]]; then
    PYPY_ARCH="osx64"
  else
    echo "Unsupported MacOS Architecture!"
    exit
  fi
else
  echo "Unsupported OS!"
  exit
fi

PYPY_FILE=pypy${PYTHON_VERSION}-v${PYPY_VERSION}-${PYPY_ARCH}
PYPY_URL=https://downloads.python.org/pypy/${PYPY_FILE}.tar.bz2



echo "**** Variables Used ****"
echo "* UNAME="${UNAME}
echo "* CURL="${CURL}
echo "* WGET="${WGET}
echo "* ARCH="${ARCH}
echo "* OS="${OS}
echo "* PYTHON_VERSION="${PYTHON_VERSION}
echo "* PYPY_VERSION="${PYPY_VERSION}
echo "* PYPY_FILE="${PYPY_FILE}
echo "* PYPY_URL="${PYPY_URL}

echo "Testing for .ansible for bootstrap operations"
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

# As mentioned above upstream binaries are now portable for linux x86_64.  So the previous binaries are no longer needed
# wget -nv https://bitbucket.org/squeaky/portable-pypy/downloads/$PYPY_PORTABLE_VERSION.tar.bz2 ;
# https://downloads.python.org/pypy/pypy3.6-v7.3.1-linux64.tar.bz2

if [ -f "${WGET}" ];then
  ${WGET} -nv ${PYPY_URL} ;
elif [ -f "${CURL}" ];then
  ${CURL} ${PYPY_URL} --output ${PYPY_FILE}.tar.bz
else
  echo "Download clients curl or wget not found!"
  exit
fi

cd $HOME/.ansible

echo "Extracting PYPY Portable binary: $PYPY_PORTABLE_VERSION"
cd $HOME/.ansible
tar -xjf tmp/${PYPY_FILE}.tar.bz

echo "Renaming ${PYPY_DIR} to pypy"
mv ${PYPY_FILE} pypy

echo "Removing downloaded PYPY tarball file ${PYPY_FILE}"
rm -rf tmp/${PYPY_FILE}.tar.bz

echo "Setting resursive permissions on pypy directory."
chmod -R ugo+x $HOME/.ansible/pypy

echo "Creating a symlink for easy use of python."
ln -f -s $HOME/.ansible/pypy/bin/pypy3 $HOME/bin/python

echo "Validating symlinked python commands"
$HOME/bin/python --version

echo "Adding HOME/bin to path"
if [ ! -e $HOME/.bash_profile ];
then
  cat <<EOF > $HOME/.bash_profile
export PATH=${HOME}/bin:$PATH
export LDFLAGS="-L${HOME}/.ansible/pypy/bin"
EOF
fi
