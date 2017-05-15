#!/bin/sh

nix-env -i boost
export BOOST_ROOT=$HOME/.nix-profile/include/
export fftw_DIR=$HOME/.nix-profile/
cmake -DWITH_BOOST=OFF -DBOOST_ROOT=/home/travis/.nix-profile/include/ -DWITH_FFTW=OFF -Dfftw_DIR=$HOME/.nix-profile $1 -DCMAKE_INSTALL_PREFIX=/home/travis/install/demonix
make install

