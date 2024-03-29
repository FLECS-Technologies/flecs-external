# Copyright 2021-2023 FLECS Technologies GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.22)

get_filename_component(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ ABSOLUTE)
if (${ROOT_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    # PkgConfig
    find_package(PkgConfig REQUIRED GLOBAL)

    # Make sure pkg-config only finds packages for the target architecture
    set(PKG_CONFIG_ARGN "--personality" "${MACHINE}")

    # Asio
    pkg_check_modules(asio REQUIRED GLOBAL IMPORTED_TARGET asio>=1.28.0)

    # cpr
    find_package(cpr 1.10.5 REQUIRED GLOBAL)
    target_link_libraries(cpr::cpr INTERFACE
        CURL::libcurl
        OpenSSL::SSL
        OpenSSL::Crypto
    )

    # gtest
    find_package(GTest 1.14.0 REQUIRED GLOBAL)

    # json
    find_package(nlohmann_json 3.11.2 REQUIRED GLOBAL)

    # libarchive
    find_package(LibArchive 3.7.2 REQUIRED GLOBAL)
    target_link_libraries(LibArchive::LibArchive INTERFACE
        OpenSSL::SSL
        OpenSSL::Crypto
    )
    target_compile_definitions(LibArchive::LibArchive INTERFACE
        -D_FILE_OFFSET_BITS=64
    )

    # libmosquitto
    pkg_check_modules(Mosquitto REQUIRED GLOBAL IMPORTED_TARGET libmosquitto>=2.0.15)

    # libusb
    pkg_check_modules(libusb REQUIRED GLOBAL IMPORTED_TARGET libusb-1.0>=1.0.26)

    # OpenSSL
    find_package(OpenSSL 3.0 REQUIRED GLOBAL)

    # yaml-cpp
    find_package(yaml-cpp REQUIRED GLOBAL)

    # zenoh-c
    find_package(zenohc 0.10.0 QUIET GLOBAL)
    if (NOT zenohc_FOUND)
        find_package(zenohc_debug 0.10.0 QUIET GLOBAL)
        if (NOT zenohc_debug_FOUND)
            find_package(zenohc 0.10.0 REQUIRED GLOBAL)
        endif()
    endif()
endif()
