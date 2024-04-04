# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindLibusb
-------

Finds the Libusb library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Libusb::Libusb``
  The Libusb library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Libusb_FOUND``
  True if the system has the Libusb library.
``Libusb_VERSION``
  The version of the Libusb library which was found.
``Libusb_INCLUDE_DIRS``
  Include directories needed to use Libusb.
``Libusb_LIBRARIES``
  Libraries needed to link to Libusb.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Libusb_INCLUDE_DIR``
  The directory containing ``mosquitto.h``.
``Libusb_LIBRARY``
  The path to the Libusb library.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_Libusb QUIET libusb-1.0)
  if(PC_Libusb_FOUND)
    set(Libusb_VERSION ${PC_Libusb_VERSION})
  endif()
endif()

find_path(Libusb_INCLUDE_DIR
  NAMES libusb-1.0/libusb.h
  PATHS ${PC_Libusb_INCLUDE_DIRS} ${Libusb_INCLUDE_HINT}
)
mark_as_advanced(Libusb_INCLUDE_DIR)

find_library(Libusb_LIBRARY
  NAMES usb-1.0
  PATHS ${PC_Libusb_LIBRARY_DIRS} ${Libusb_LIB_HINT}
)

find_package_handle_standard_args(Libusb
  FOUND_VAR Libusb_FOUND
  REQUIRED_VARS
    Libusb_LIBRARY
    Libusb_INCLUDE_DIR
  VERSION_VAR Libusb_VERSION
)

if(Libusb_FOUND)
  set(Libusb_LIBRARIES ${Libusb_LIBRARY})
  set(Libusb_INCLUDE_DIRS ${Libusb_INCLUDE_DIR})
  set(Libusb_DEFINITIONS ${PC_Libusb_CFLAGS_OTHER})

  # Determine Libusb version, if not done by pkg-config
  if (NOT Libusb_VERSION)
    file(STRINGS ${Libusb_INCLUDE_DIR}/libusb-1.0/libusb.h libusb_api_version REGEX "^#define LIBUSB_API_VERSION .+")
    string(REGEX REPLACE "^#define LIBUSB_API_VERSION (.+)$" "\\1" libusb_api_version "${libusb_api_version}")
    file(STRINGS ${Libusb_INCLUDE_DIR}/libusb-1.0/libusb.h libusb_api_version REGEX "LIBUSB_API_VERSION = ${libusb_api_version}")
    string(REGEX REPLACE "^.+libusb version (.+):.+" "\\1" Libusb_VERSION "${libusb_api_version}")

    find_package_handle_standard_args(Libusb
      FOUND_VAR Libusb_FOUND
      REQUIRED_VARS
        Libusb_LIBRARY
        Libusb_INCLUDE_DIR
      VERSION_VAR Libusb_VERSION
    )

    unset(libusb_api_version)
  endif()

  if (NOT TARGET Libusb::Libusb)
    add_library(Libusb::Libusb UNKNOWN IMPORTED)
    set_target_properties(Libusb::Libusb PROPERTIES
      IMPORTED_LOCATION "${Libusb_LIBRARY}"
      INTERFACE_COMPILE_OPTIONS "${PC_Libusb_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Libusb_INCLUDE_DIR}"
    )
  endif()
endif()
