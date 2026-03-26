
cmake_minimum_required(VERSION 4.2.3)

project(VectorArithmetic)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


## Library ##

add_library(vector_arith_lib
    src/FloatVector.cpp
    src/vector_arith.cpp
)

target_include_directories(vector_arith_lib
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)


## FMT dependency ##

include(FetchContent)

FetchContent_Declare(
  fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG 10.2.1
)

FetchContent_MakeAvailable(fmt)

target_link_libraries(vector_arith_lib PRIVATE fmt::fmt)

## Executable ##

add_executable(vector_arith_cli
    apps/main.cpp
)

target_link_libraries(vector_arith_cli
    PRIVATE vector_arith_lib
)

## Google Test dependency ##

# download and compile google test
include(FetchContent)

FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)

FetchContent_MakeAvailable(googletest)

enable_testing()

# create test executable and link it to our vector arithmetic library
add_executable(
  vector_arith_test
  test/float_vector_test.cpp
  test/vector_arith_test.cpp
)

target_link_libraries(
  vector_arith_test
  GTest::gtest_main
  vector_arith_lib
)

# tell Google Test to search for unit tests
include(GoogleTest)
gtest_discover_tests(vector_arith_test)
