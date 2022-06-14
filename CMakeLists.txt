cmake_minimum_required(VERSION 3.19)

project(STDIN_examples LANGUAGES CXX)

enable_testing()

find_package(Matlab COMPONENTS MAIN_PROGRAM REQUIRED)
# --- test values (arbitrary)
set(a 5)
set(b 3)
math(EXPR c "${a} + ${b}")

# --- test executable
add_executable(main main.cpp)
# add_executable(main_fortran main.f90)

# --- Matlab + Java: stdin pipe example

add_test(NAME MatlabJavaCXX
COMMAND ${Matlab_MAIN_PROGRAM} -batch "assert(main_java(${a}, ${b}) == ${c})"
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

# --- Matlab + Python: stdin pipe example

add_test(NAME MatlabPythonCXX
COMMAND ${Matlab_MAIN_PROGRAM} -batch "assert(main_python(${a}, ${b}) == ${c})"
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

set_tests_properties(MatlabJavaCXX MatlabPythonCXX PROPERTIES
TIMEOUT 90
)
