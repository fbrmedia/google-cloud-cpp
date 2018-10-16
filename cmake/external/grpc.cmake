# ~~~
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ~~~

include(external/c-ares)
include(external/protobuf)

if (NOT TARGET gprc_project)
    # Give application developers a hook to configure the version and hash
    # downloaded from GitHub.
    set(GOOGLE_CLOUD_CPP_GRPC_URL
        "https://github.com/grpc/grpc/archive/v1.14.1.tar.gz")
    set(GOOGLE_CLOUD_CPP_GRPC_SHA256
        "16f22430210abf92e06626a5a116e114591075e5854ac78f1be8564171658b70")

    if ("${CMAKE_GENERATOR}" STREQUAL "Unix Makefiles"
        OR "${CMAKE_GENERATOR}" STREQUAL "Ninja")
        include(ProcessorCount)
        processorcount(NCPU)
        set(PARALLEL "--" "-j" "${NCPU}")
    else()
        set(PARALLEL "")
    endif ()

    include(ExternalProject)
    externalproject_add(
        grpc_project
        DEPENDS c_ares_project protobuf_project
        EXCLUDE_FROM_ALL ON
        PREFIX "external/grpc"
        INSTALL_DIR "external"
        URL ${GOOGLE_CLOUD_CPP_GRPC_URL}
        URL_HASH SHA256=${GOOGLE_CLOUD_CPP_GRPC_SHA256}
        CMAKE_ARGS ${GOOGLE_CLOUD_CPP_EXTERNAL_PROJECT_CCACHE}
                   -DCMAKE_BUILD_TYPE=Release
                   -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
                   -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                   -DCMAKE_PREFIX_PATH=<INSTALL_DIR>
                   -DgRPC_BUILD_TESTS=OFF
                   -DgRPC_ZLIB_PROVIDER=package
                   -DgRPC_SSL_PROVIDER=package
                   -DgRPC_CARES_PROVIDER=package
                   -DgRPC_PROTOBUF_PROVIDER=package
        BUILD_COMMAND ${CMAKE_COMMAND}
                      --build
                      <BINARY_DIR>
                      ${PARALLEL}
        BUILD_BYPRODUCTS
            <INSTALL_DIR>/lib/libgrpc${CMAKE_STATIC_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libgrpc${CMAKE_SHARED_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libgrpc++${CMAKE_STATIC_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libgrpc++${CMAKE_SHARED_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libgpr${CMAKE_STATIC_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libgpr${CMAKE_SHARED_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libaddress_sorting${CMAKE_STATIC_LIBRARY_SUFFIX}
            <INSTALL_DIR>/lib/libaddress_sorting${CMAKE_SHARED_LIBRARY_SUFFIX}
            <INSTALL_DIR>/bin/grpc_cpp_plugin${CMAKE_EXECUTABLE_SUFFIX}
        LOG_DOWNLOAD ON
        LOG_CONFIGURE ON
        LOG_BUILD ON
        LOG_INSTALL ON)
endif ()
