# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindMosquitto
-------

Finds the Mosquitto library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Mosquitto::Mosquitto``
  The Mosquitto library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Mosquitto_FOUND``
  True if the system has the Mosquitto library.
``Mosquitto_VERSION``
  The version of the Mosquitto library which was found.
``Mosquitto_INCLUDE_DIRS``
  Include directories needed to use Mosquitto.
``Mosquitto_LIBRARIES``
  Libraries needed to link to Mosquitto.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Mosquitto_INCLUDE_DIR``
  The directory containing ``mosquitto.h``.
``Mosquitto_LIBRARY``
  The path to the Mosquitto library.

#]=======================================================================]

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_Mosquitto QUIET libmosquitto)
  if(PC_Mosquitto_FOUND)
    set(Mosquitto_VERSION ${PC_Mosquitto_VERSION})
  endif()
endif()

find_path(Mosquitto_INCLUDE_DIR
  NAMES mosquitto.h
  PATHS ${PC_Mosquitto_INCLUDE_DIRS} ${Mosquitto_INCLUDE_HINT}
)
mark_as_advanced(Mosquitto_INCLUDE_DIR)

find_library(Mosquitto_LIBRARY
  NAMES mosquitto
  PATHS ${PC_Mosquitto_LIBRARY_DIRS} ${Mosquitto_LIB_HINT}
)

find_package_handle_standard_args(Mosquitto
  FOUND_VAR Mosquitto_FOUND
  REQUIRED_VARS
    Mosquitto_LIBRARY
    Mosquitto_INCLUDE_DIR
  VERSION_VAR Mosquitto_VERSION
)

if(Mosquitto_FOUND)
  set(Mosquitto_LIBRARIES ${Mosquitto_LIBRARY})
  set(Mosquitto_INCLUDE_DIRS ${Mosquitto_INCLUDE_DIR})
  set(Mosquitto_DEFINITIONS ${PC_Mosquitto_CFLAGS_OTHER})

  # Determine Mosquitto version, if not done by pkg-config
  if (NOT Mosquitto_VERSION)
    file(STRINGS ${Mosquitto_INCLUDE_DIR}/mosquitto.h mosquitto_version_major REGEX "^#define LIBMOSQUITTO_MAJOR.+")
    file(STRINGS ${Mosquitto_INCLUDE_DIR}/mosquitto.h mosquitto_version_minor REGEX "^#define LIBMOSQUITTO_MINOR.+")
    file(STRINGS ${Mosquitto_INCLUDE_DIR}/mosquitto.h mosquitto_version_revision REGEX "^#define LIBMOSQUITTO_REVISION.+")
    
    string(REGEX REPLACE "^#define LIBMOSQUITTO_MAJOR ([0-9]+)" "\\1" mosquitto_version_major "${mosquitto_version_major}")
    string(REGEX REPLACE "^#define LIBMOSQUITTO_MINOR ([0-9]+)" "\\1" mosquitto_version_minor "${mosquitto_version_minor}")
    string(REGEX REPLACE "^#define LIBMOSQUITTO_REVISION ([0-9]+)" "\\1" mosquitto_version_revision "${mosquitto_version_revision}")
    
    set(Mosquitto_VERSION "${mosquitto_version_major}.${mosquitto_version_minor}.${mosquitto_version_revision}")

    find_package_handle_standard_args(Mosquitto
      FOUND_VAR Mosquitto_FOUND
      REQUIRED_VARS
        Mosquitto_LIBRARY
        Mosquitto_INCLUDE_DIR
      VERSION_VAR Mosquitto_VERSION
    )

    unset(mosquitto_version_major)
    unset(mosquitto_version_minor)
    unset(mosquitto_version_revision)
  endif()

  # Determine Mosquitto TLS support
  execute_process(
    COMMAND ${CMAKE_OBJDUMP} -T ${Mosquitto_LIBRARY}
    OUTPUT_VARIABLE Mosquitto_OBJDUMP_SYMBOLS
    ERROR_QUIET
    RESULT_VARIABLE Mosquitto_OBJDUMP_RESULT
  )
  execute_process(
    COMMAND echo ${Mosquitto_OBJDUMP_SYMBOLS}
    COMMAND grep OPENSSL_init_crypto
    OUTPUT_QUIET
    ERROR_QUIET
    RESULT_VARIABLE Mosquitto_HAVE_TLS
  )
  if (${Mosquitto_HAVE_TLS} EQUAL 0)
    set(Mosquitto_HAVE_TLS TRUE)
  endif()

  if (NOT TARGET Mosquitto::Mosquitto)
    add_library(Mosquitto::Mosquitto UNKNOWN IMPORTED)
    set_target_properties(Mosquitto::Mosquitto PROPERTIES
      IMPORTED_LOCATION "${Mosquitto_LIBRARY}"
      INTERFACE_COMPILE_OPTIONS "${PC_Mosquitto_CFLAGS_OTHER}"
      INTERFACE_INCLUDE_DIRECTORIES "${Mosquitto_INCLUDE_DIR}"
    )
    if (Mosquitto_HAVE_TLS)
      find_package(OpenSSL REQUIRED QUIET)
      target_link_libraries(Mosquitto::Mosquitto INTERFACE
        OpenSSL::SSL
        OpenSSL::Crypto
      )
    endif()
  endif()
endif()
