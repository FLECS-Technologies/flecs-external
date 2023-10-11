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

get_filename_component(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} ABSOLUTE)
if (${ROOT_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    # PkgConfig
    find_package(PkgConfig REQUIRED)

    # cpr
    find_package(cpr 1.10.4 REQUIRED)
    target_link_libraries(cpr::cpr INTERFACE
        CURL::libcurl
        OpenSSL::SSL
        OpenSSL::Crypto
    )

    # gtest
    find_package(GTest 1.14.0 REQUIRED)

    # json
    find_package(nlohmann_json 3.11.2 REQUIRED)

    # libarchive
    find_package(LibArchive 3.7.2 REQUIRED)
    target_link_libraries(LibArchive::LibArchive INTERFACE
        OpenSSL::SSL
        OpenSSL::Crypto
    )

    # libmosquitto
    pkg_check_modules(Mosquitto REQUIRED IMPORTED_TARGET libmosquitto>=2.0.15)

    # libusb
    pkg_check_modules(libusb REQUIRED IMPORTED_TARGET libusb-1.0>=1.0.26)

    # OpenSSL
    find_package(OpenSSL 3.0 REQUIRED)

    # yaml-cpp
    find_package(yaml-cpp REQUIRED)

    # zenoh-c
    add_library(external.zenoh-c INTERFACE)
    target_link_libraries(external.zenoh-c INTERFACE
        zenohc
    )
endif()
