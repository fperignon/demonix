#ifndef DEMONIX_INTERFACE_HPP
#define DEMONIX_INTERFACE_HPP
#include "demonix_config.hpp"

// Boost, fftw and mkl interfaces
// are optional. CMake is supposed
// to control this, depending on
// the availability of those libraries
// on the system, thanks to the
// generated file demonix_config.hpp.

// Boost
#ifdef HAS_BOOST
#include "linearAlgebraTools.hpp"
#endif

// fftw
#ifdef HAS_FFTW
#include "fftw_tools.hpp"
#endif

// mkl
#ifdef HAS_MKL
#include "mkl_interface.hpp"
#endif

#endif
