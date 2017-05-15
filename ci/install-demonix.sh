#!/bin/sh

cmake -DWITH_BOOST=ON -DBOOST_ROOT=~/.nix-profile/include -DWITH_FFTW=ON -Dfftw_DIR=~/.nix-profile $1
make install

