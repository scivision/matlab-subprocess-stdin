cmake_minimum_required(VERSION 3.19)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "use out-of-source build:
  cmake -Bbuild")
endif()

project(STDIN_examples LANGUAGES CXX)

enable_testing()

set(CMAKE_FIND_FRAMEWORK LAST)

find_package(Matlab COMPONENTS MAIN_PROGRAM REQUIRED)
# --- test values (arbitrary)
set(a 5)
set(b 3)
math(EXPR c "${a} + ${b}")

# --- test executables
add_executable(stdin_sum_print stdin_sum_print.cpp)
add_executable(env_print env_print.cpp)
# add_executable(main_fortran main.f90)

add_test(NAME MatlabSubprocess
COMMAND ${Matlab_MAIN_PROGRAM} -batch
  "r = runtests('${CMAKE_CURRENT_SOURCE_DIR}'); assert(~isempty(r)), assert(sum([r.Incomplete])==0), assertSuccess(r)"
)


set_property(TEST MatlabSubprocess PROPERTY TIMEOUT 90)
set_property(TEST MatlabSubprocess PROPERTY WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

file(GENERATE OUTPUT .gitignore CONTENT "*")
