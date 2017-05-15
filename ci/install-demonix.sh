#!/bin/sh

ls $HOME/.nix-profile
cmake -DWITH_BOOST=ON -DBOOST_ROOT=$HOME/.nix-profile/include -DWITH_FFTW=ON -Dfftw_DIR=$HOME/.nix-profile $1
make install

