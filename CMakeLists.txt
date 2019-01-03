# Tencent is pleased to support the open source community by making xLua available.
# Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
# Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
# http://opensource.org/licenses/MIT
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

cmake_minimum_required(VERSION 2.8)

set(CMAKE_BUILD_TYPE Debug)

if ( WIN32 AND NOT CYGWIN AND NOT ( CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" ) AND NOT ANDROID)
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd" CACHE STRING "")
endif ()

project(XLua)

ADD_DEFINITIONS("-DLUA_32BITS_STRING")

if ( IOS )
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fembed-bitcode")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fembed-bitcode")
        ADD_DEFINITIONS("-DXLUA_IOS")
endif ()

option ( UINT_ESPECIALLY "using custom ulong" OFF )
option ( LUAC_COMPATIBLE_FORMAT "compatible format" ON )

find_path(XLUA_PROJECT_DIR NAMES SConstruct
    PATHS 
    ${CMAKE_SOURCE_DIR}
    NO_DEFAULT_PATH
    )

MARK_AS_ADVANCED(XLUA_PROJECT_DIR)

#begin lua-rapidjson
set (RAPIDJSON_SRC lua-rapidjson/source/rapidjson.cpp)
set_property(
    SOURCE ${RAPIDJSON_SRC}
    APPEND
    PROPERTY COMPILE_DEFINITIONS
    LUA_LIB
)
list(APPEND THIRDPART_INC lua-rapidjson/include)
set (THIRDPART_SRC ${THIRDPART_SRC} ${RAPIDJSON_SRC})
#end lua-rapidjson

#begin lua-protobuf
set (PROTOBUF_SRC lua-protobuf/pb.c)
list(APPEND THIRDPART_INC lua-protobuf)
set (THIRDPART_SRC ${THIRDPART_SRC} ${PROTOBUF_SRC})
#end lua-protobuf

#begin lua-fixmath
set (FIXMATH_SRC lua-fixmath/src/fixmath_impl.c lua-fixmath/src/fixmath_str.c lua-fixmath/src/fixmath.c lua-fixmath/src/luabinding.c)
list(APPEND THIRDPART_INC lua-fixmath/include)
set (THIRDPART_SRC ${THIRDPART_SRC} ${FIXMATH_SRC})
#end lua-fixmath

set ( LUA_IDSIZE 120 CACHE NUMBER "gives the maximum size for the description of the source." )

configure_file ( lua-5.3.5/src/luaconf.h.in ${CMAKE_CURRENT_BINARY_DIR}/luaconf.h )

include_directories(
    ${CMAKE_SOURCE_DIR}
    lua-5.3.5/src
    ${CMAKE_CURRENT_BINARY_DIR}
    ${THIRDPART_INC}
)

set ( LUA_CORE lua-5.3.5/src/lapi.c lua-5.3.5/src/lcode.c lua-5.3.5/src/lctype.c lua-5.3.5/src/ldebug.c lua-5.3.5/src/ldo.c lua-5.3.5/src/ldump.c
    lua-5.3.5/src/lfunc.c lua-5.3.5/src/lgc.c lua-5.3.5/src/llex.c lua-5.3.5/src/lmem.c lua-5.3.5/src/lobject.c lua-5.3.5/src/lopcodes.c lua-5.3.5/src/lparser.c
    lua-5.3.5/src/lstate.c lua-5.3.5/src/lstring.c lua-5.3.5/src/ltable.c lua-5.3.5/src/ltm.c lua-5.3.5/src/lundump.c lua-5.3.5/src/lvm.c lua-5.3.5/src/lzio.c )
set ( LUA_LIB lua-5.3.5/src/lauxlib.c lua-5.3.5/src/lbaselib.c lua-5.3.5/src/lbitlib.c lua-5.3.5/src/lcorolib.c lua-5.3.5/src/ldblib.c
    lua-5.3.5/src/liolib.c lua-5.3.5/src/lmathlib.c lua-5.3.5/src/loslib.c lua-5.3.5/src/lstrlib.c lua-5.3.5/src/ltablib.c lua-5.3.5/src/linit.c
    lua-5.3.5/src/lutf8lib.c lua-5.3.5/src/loadlib.c )

set ( LUA_SOCKET
    luasocket/auxiliar.c
    luasocket/buffer.c
    luasocket/except.c
    luasocket/inet.c
    luasocket/io.c
    luasocket/luasocket.c
    luasocket/mime.c
    luasocket/options.c
    luasocket/select.c
    luasocket/tcp.c
    luasocket/timeout.c
    luasocket/udp.c 
)

if ( WIN32 AND NOT CYGWIN )
    list (APPEND LUA_SOCKET luasocket/wsocket.c)
else ( )
    list (APPEND LUA_SOCKET luasocket/usocket.c)
endif ( )

set ( XLUA_CORE
    i64lib.c
    perflib.c
    xlua.c
)

if (NOT USING_LUAJIT)
    list (APPEND XLUA_CORE memory_leak_checker.c)
endif ( )

macro(source_group_by_dir proj_dir source_files)
    if(MSVC OR APPLE)
        get_filename_component(sgbd_cur_dir ${proj_dir} ABSOLUTE)
        foreach(sgbd_file ${${source_files}})
            get_filename_component(sgbd_abs_file ${sgbd_file} ABSOLUTE)
            file(RELATIVE_PATH sgbd_fpath ${sgbd_cur_dir} ${sgbd_abs_file})
            string(REGEX REPLACE "\(.*\)/.*" \\1 sgbd_group_name ${sgbd_fpath})
            string(COMPARE EQUAL ${sgbd_fpath} ${sgbd_group_name} sgbd_nogroup)
            string(REPLACE "/" "\\" sgbd_group_name ${sgbd_group_name})
            if(sgbd_nogroup)
                set(sgbd_group_name "\\")
            endif(sgbd_nogroup)
            source_group(${sgbd_group_name} FILES ${sgbd_file})
        endforeach(sgbd_file)
    endif(MSVC OR APPLE)
endmacro(source_group_by_dir)

source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LUA_SOCKET)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LUA_CORE)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LUA_LIB)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} XLUA_CORE)

if (APPLE)
    if (IOS)
        set(CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD)")
        add_library(xlua STATIC
           ${LUA_CORE}
           ${LUA_LIB}
           ${LUA_SOCKET}
           ${XLUA_CORE}
           ${THIRDPART_SRC}
        )
        set_xcode_property (xlua IPHONEOS_DEPLOYMENT_TARGET "7.0")
    else ()
        set(CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD_64_BIT)")
        add_library(xlua MODULE
            ${LUA_CORE}
            ${LUA_LIB}
            ${LUA_SOCKET}
            ${XLUA_CORE}
            ${THIRDPART_SRC}
        )
        set_target_properties ( xlua PROPERTIES BUNDLE TRUE )
        add_executable(run_xlua 
            "main.c"
            ${LUA_CORE}
            ${LUA_LIB}
            ${XLUA_CORE}
            ${THIRDPART_SRC}
        )
    endif ()
else ( )
    add_library(xlua SHARED
        ${LUA_CORE}
        ${LUA_LIB}
        ${LUA_SOCKET}
        ${XLUA_CORE}
        ${THIRDPART_SRC}
    )
endif ( )

if ( WIN32 AND NOT CYGWIN )
    target_compile_definitions (xlua PRIVATE LUA_BUILD_AS_DLL)
endif ( )

if (LUAC_COMPATIBLE_FORMAT AND NOT USING_LUAJIT)
    target_compile_definitions (xlua PRIVATE LUAC_COMPATIBLE_FORMAT)
endif ()
set_property(
	SOURCE ${LUA_SOCKET}
	APPEND
	PROPERTY COMPILE_DEFINITIONS
	LUA_COMPAT_APIINTCASTS LUA_LIB _CRT_SECURE_NO_WARNINGS _WINSOCK_DEPRECATED_NO_WARNINGS
)

if(UINT_ESPECIALLY)
    ADD_DEFINITIONS(-DUINT_ESPECIALLY)
endif()
	
if ( WIN32 AND NOT CYGWIN )
        target_link_libraries(xlua
            ws2_32
            ${THIRDPART_LIB} 
        )
else ( )
        target_link_libraries(xlua
            m
            ${THIRDPART_LIB} 
        )
endif ( )
