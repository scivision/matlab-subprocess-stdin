cmake_minimum_required(VERSION 3.19...3.23)
project(STDIN_examples LANGUAGES CXX)
enable_testing()

# --- test values (arbitrary)
set(a 5)
set(b 3)
math(EXPR c "${a} + ${b}")

# --- test executable
add_executable(main_cpp main.cpp)
# add_executable(main_fortran main.f90)

# --- Matlab + Java: stdin pipe example
find_package(Matlab 9.8 COMPONENTS MAIN_PROGRAM REQUIRED)

add_test(NAME MatlabJavaCXX
COMMAND ${Matlab_MAIN_PROGRAM} -batch "assert(main_java(${a}, ${b}) == ${c})"
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
set_tests_properties(MatlabJavaCXX PROPERTIES
TIMEOUT 90
)

# --- Matlab + Python: stdin pipe example
find_package(Python 3.7 COMPONENTS Interpreter)
if(Python_FOUND)
  add_test(NAME MatlabPythonCXX
  COMMAND ${Matlab_MAIN_PROGRAM} -batch "assert(main_python(${a}, ${b}) == ${c})"
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  )
  set_tests_properties(MatlabPythonCXX PROPERTIES
  TIMEOUT 90
  )
endif()
