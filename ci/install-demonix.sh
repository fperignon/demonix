#!/bin/sh

ls -altr $HOME/.nix-profile/include
ls -altr $HOME/.nix-profile/lib
cmake -DWITH_BOOST=ON -DBOOST_ROOT=$HOME/.nix-profile/include -DWITH_FFTW=ON -Dfftw_DIR=$HOME/.nix-profile $1
make install

