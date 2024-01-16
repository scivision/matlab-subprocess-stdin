cmake_minimum_required(VERSION 3.19)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "use out-of-source build:
  cmake -Bbuild")
endif()

project(STDIN_examples LANGUAGES CXX)

enable_testing()

message(STATUS "CMake ${CMAKE_VERSION}")

set(CMAKE_MODULE_PATH "c:/users/micha/code_other/cmake/Modules")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_BINARY_DIR})

find_package(Matlab COMPONENTS MAIN_PROGRAM)
# not REQUIRED because we don't need default MEX stuff
message(STATUS "Matlab_MAIN_PROGRAM: ${Matlab_MAIN_PROGRAM}")

matlab_get_all_valid_matlab_roots_from_registry("${Matlab_VERSION}" roots)

matlab_get_release_name_from_version("${Matlab_VERSION}" r)
message(STATUS "Matlab ${Matlab_VERSION} release: ${r} roots: ${roots}")

# --- test executables
add_executable(stdin_sum_print test/stdin_sum_print.cpp)
add_executable(env_print test/env_print.cpp)
# add_executable(main_fortran main.f90)

add_test(NAME MatlabSubprocess
COMMAND ${Matlab_MAIN_PROGRAM} -batch
  "r = runtests('${CMAKE_CURRENT_SOURCE_DIR}/test'); assert(~isempty(r)), assertSuccess(r)"
)

set_property(TEST MatlabSubprocess PROPERTY TIMEOUT 90)
set_property(TEST MatlabSubprocess PROPERTY WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

file(GENERATE OUTPUT .gitignore CONTENT "*")
