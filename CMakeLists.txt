# ---- A simple library used as demo for nix-tutorial ----
# 
# - c++
# - external (optional) deps: boost, fftw
#

# --- CMake standard conf ---
# Set minimal cmake version
cmake_minimum_required(VERSION 3.0)

# Set path to user-defined cmake macros and functions
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(demonix_tools)
# Defaut build mode (release)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()

# Set user-defined options
option(WITH_FFTW "Recherche de fftw, defaut = OFF" OFF)
option(WITH_MKL "utilisation de la bibliotheque mkl, defaut = OFF" OFF)
option(WITH_BOOST "utilisation de la boost, defaut = OFF" OFF)

# Set project name and languages
project(demonix CXX)
# Install lib directory 32, 64 etc. on Fedora, Debian 
# http://public.kitware.com/Bug/view.php?id=11964
# See also http://www.cmake.org/cmake/help/v3.0/module/GNUInstallDirs.html?highlight=gnuinstalldirs
include(GNUInstallDirs)
# Set prefix path for libraries installation
# --> means that any library target will be installed
# in CMAKE_INSTALL_PREFIX/_install_lib
if(${PROJECT_NAME}_INSTALL_LIB_DIR)
  set(_install_lib ${${PROJECT_NAME}_INSTALL_LIB_DIR})
else()
  set(_install_lib ${CMAKE_INSTALL_LIBDIR})
  set(${PROJECT_NAME}_INSTALL_LIB_DIR ${_install_lib})
endif()
# --- RPATH stuff ---
# See https://cmake.org/Wiki/CMake_RPATH_handling

set(CMAKE_SKIP_BUILD_RPATH FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
if("${isSystemDir}" STREQUAL "-1")
  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${_install_lib}")
endif()

# --- Deps setup : search include and libraries paths ---
set(EXTERNAL_LIBS)

# Boost
if(WITH_BOOST)
  find_package(Boost REQUIRED)
  if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS})
    set(HAS_BOOST 1)
  endif()
endif()

# FFTW
if(WITH_FFTW)
  find_package(FFTW REQUIRED)
  include_directories(${FFTW_INCLUDE_DIRS})
  set(HAS_FFTW 1) # pour config.hpp
  list(APPEND EXTERNAL_LIBS ${FFTW_LIBRARIES})
endif()

# MKL
if(WITH_MKL)
  #find_package(MKL REQUIRED)
  set(MKL_INCLUDE_DIRS $ENV{mkl_DIR})
  include_directories(${MKL_INCLUDE_DIRS})
  SET(CMAKE_CXX_FLAGS "-mkl ${CMAKE_CXX_FLAGS}")
  set(HAS_MKL 1) # pour config.hpp
endif()

# Generate demonix_config.hpp
# preprocessing macros depending on find results above
if(EXISTS ${CMAKE_SOURCE_DIR}/config.hpp.cmake)
  configure_file(${CMAKE_SOURCE_DIR}/config.hpp.cmake demonix_config.hpp)
  include_directories(${CMAKE_BINARY_DIR})
endif()

# ---- Get demonix sources ---
set(demonix_SRC_DIRS
  src/tools/
  )

if(HAS_FFTW)
  # Add files based on fftw
  list(APPEND demonix_SRC_DIRS
    src/tools/fft
    )
endif()

get_sources(${demonix_SRC_DIRS})
set(demonix_SRC ${SOURCES_FILES})
get_headers(${demonix_SRC_DIRS})
set(demonix_HEADERS ${HEADERS_FILES})

# Headers directories
include_directories(${demonix_SRC_DIRS})

# Build library from detected source files
add_library(demonix SHARED ${demonix_SRC})

# Link library with ext. deps
target_link_libraries(demonix ${EXTERNAL_LIBS})

# Build a binary, using the library just created above
add_executable(run_demonix src/main.cpp)
# link avec notre librairie
target_link_libraries(run_demonix demonix)


# --- install ---


install(TARGETS run_demonix demonix
  RUNTIME DESTINATION bin  # binaries
  ARCHIVE DESTINATION ${_install_lib}  # static libs
  LIBRARY DESTINATION ${_install_lib}  # shared libs
  )
# headers
install(FILES ${demonix_HEADERS} DESTINATION include)
# cmake utils
install(DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY} DESTINATION include)

# --- uninstall target ---
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
  IMMEDIATE @ONLY)
add_custom_target(uninstall
  echo >> ${CMAKE_CURRENT_BINARY_DIR}/install_manifest.txt
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)




message(STATUS "====================== Summary ======================")
message(STATUS " Fortran compiler : ${CMAKE_Fortran_COMPILER}")
message(STATUS " CXX compiler : ${CMAKE_CXX_COMPILER}")
if(HAS_FFTW)
  message(STATUS " FFTW libs found : ${FFTW_LIBRARIES}")
  message(STATUS " FFTW Headers : ${FFTW_INCLUDE_DIRS}")
else()
  message(STATUS " FFTW not found")
endif()
if(HAS_BOOST)
  message(STATUS " Boost found in : ${Boost_INCLUDE_DIRS}")
else()
  message(STATUS " Boost not found.")
endif()
message(STATUS " Sources are in : ${CMAKE_SOURCE_DIR}")
message(STATUS " Project will be installed in ${CMAKE_INSTALL_PREFIX}")
message(STATUS " CMake build type is : ${CMAKE_BUILD_TYPE}")

