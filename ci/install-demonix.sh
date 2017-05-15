#!/bin/sh

nix-env -i boost
ls -altr $HOME/.nix-profile/include
ls -altr $HOME/.nix-profile/lib
export BOOST_ROOT=$HOME/.nix-profile/include/
export fftw_DIR=$HOME/.nix-profile/
cmake -DWITH_BOOST=OFF -DBOOST_ROOT=/home/travis/.nix-profile/include/ -DWITH_FFTW=OFF -Dfftw_DIR=$HOME/.nix-profile $1
make install

