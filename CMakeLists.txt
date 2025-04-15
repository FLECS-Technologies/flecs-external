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

cmake_minimum_required(VERSION 3.24)

get_filename_component(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../ ABSOLUTE)
if(${ROOT_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

    # Configure PkgConfig, if present
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        # Make sure pkg-config only finds packages for the target architecture
        set(PKG_CONFIG_ARGN "--personality" "${MACHINE}")
    endif()

    # Asio
    if(FLECS_NEED_ASIO)
        find_package(Asio 1.28.0 REQUIRED GLOBAL)
    endif()

    # cpr
    if(FLECS_NEED_CPR)
        find_package(cpr 1.11.1 REQUIRED GLOBAL)
        target_link_libraries(cpr::cpr INTERFACE
            CURL::libcurl
            OpenSSL::SSL
            OpenSSL::Crypto
        )
    endif()

    # gtest
    if(FLECS_NEED_GTEST)
        find_package(GTest 1.14.0 REQUIRED GLOBAL)
    endif()

    # json
    if(FLECS_NEED_JSON)
        find_package(nlohmann_json 3.11.2 REQUIRED GLOBAL)
    endif()

    # libarchive
    if(FLECS_NEED_LIBARCHIVE)
        # depends on OpenSSL
        set(FLECS_NEED_OPENSSL TRUE)
        find_package(LibArchive 3.7.2 REQUIRED GLOBAL)
        target_link_libraries(LibArchive::LibArchive INTERFACE
            OpenSSL::SSL
            OpenSSL::Crypto
        )
        target_compile_definitions(LibArchive::LibArchive INTERFACE
            -D_FILE_OFFSET_BITS=64
        )
    endif()

    # libmosquitto
    if(FLECS_NEED_MOSQUITTO)
        # depends on OpenSSL
        set(FLECS_NEED_OPENSSL TRUE)
        find_package(Mosquitto 2.0.15 REQUIRED GLOBAL)
    endif()

    # libusb
    if(FLECS_NEED_LIBUSB)
        find_package(Libusb 1.0.26 REQUIRED GLOBAL)
    endif()

    # OpenSSL
    if(FLECS_NEED_OPENSSL)
        find_package(OpenSSL 3.0 REQUIRED GLOBAL)
    endif()

    # yaml-cpp
    if(FLECS_NEED_YAMLCPP)
        find_package(yaml-cpp REQUIRED GLOBAL)
    endif()
endif()
