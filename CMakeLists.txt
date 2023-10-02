cmake_minimum_required(VERSION 3.19)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "use out-of-source build:
  cmake -Bbuild")
endif()

project(STDIN_examples LANGUAGES CXX)

enable_testing()

message(STATUS "CMake ${CMAKE_VERSION}")

find_package(Matlab COMPONENTS MAIN_PROGRAM)
# not REQUIRED because we don't need default MEX stuff
message(STATUS "Matlab_MAIN_PROGRAM: ${Matlab_MAIN_PROGRAM}")

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
