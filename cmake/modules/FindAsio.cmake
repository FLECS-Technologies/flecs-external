# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindAsio
-------

Finds the Asio library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Asio::Asio``
  The Asio library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Asio_FOUND``
  True if the system has the Asio library.
``Asio_VERSION``
  The version of the Asio library which was found.
``Asio_INCLUDE_DIRS``
  Include directories needed to use Asio.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Asio_INCLUDE_DIR``
  The directory containing ``asio.hpp``.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_Asio QUIET asio)
  if(PC_Asio_FOUND)
    set(Asio_VERSION ${PC_Asio_VERSION})
  endif()
endif()

find_path(Asio_INCLUDE_DIR
  NAMES asio.hpp
  PATHS ${PC_Asio_INCLUDE_DIRS} ${Asio_INCLUDE_HINT}
)
mark_as_advanced(Asio_INCLUDE_DIR)

find_package_handle_standard_args(Asio
  FOUND_VAR Asio_FOUND
  REQUIRED_VARS
    Asio_INCLUDE_DIR
  VERSION_VAR Asio_VERSION
)

if(Asio_FOUND)
  set(Asio_INCLUDE_DIRS ${Asio_INCLUDE_DIR})
  set(Asio_DEFINITIONS ${PC_Asio_CFLAGS_OTHER})

  # Determine Asio version, if not done by pkg-config
  if (NOT Asio_VERSION)
    file(STRINGS ${Asio_INCLUDE_DIR}/asio/version.hpp asio_version REGEX "^#define ASIO_VERSION .+")
    string(REGEX REPLACE "^.+\/\/ (.+)$" "\\1" Asio_VERSION "${asio_version}")
    unset(asio_version)

    find_package_handle_standard_args(Asio
      FOUND_VAR Asio_FOUND
      REQUIRED_VARS
        Asio_INCLUDE_DIR
      VERSION_VAR Asio_VERSION
    )
  endif()

  if (NOT TARGET Asio::Asio)
    add_library(Asio::Asio UNKNOWN IMPORTED)
    set_target_properties(Asio::Asio PROPERTIES
      INTERFACE_COMPILE_OPTIONS "${PC_Asio_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Asio_INCLUDE_DIR}"
    )
  endif()
endif()
