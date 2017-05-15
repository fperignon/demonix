#include <iostream>
#include "demonix_interface.hpp"

using namespace std;

int main(int argc, char* argv[])
{

  cout << "Call demonix program" << endl;

#ifdef HAS_BOOST
  linearAlgebraTools latools(3);
  latools.display();
  std::cout << "Boost is on ..." << std::endl;
#else
  std::cout << "Boost is off ..." << std::endl;
#endif

#ifdef HAS_FFTW
  std::cout << "FFTW is on ..." << std::endl;
  apply_fftw();
#ifdef FLOAT_PREC
  apply_fftwf();
#endif
#else
  std::cout << "FFTW is off ..." << std::endl;
#endif
#ifdef HAS_MKL
  std::cout << "MKL is on ..." << std::endl;
  apply_mkl();
#else
  std::cout << "MKL is off ..." << std::endl;
#endif
}
