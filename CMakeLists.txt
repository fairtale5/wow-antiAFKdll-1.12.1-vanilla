cmake_minimum_required(VERSION 3.10)
project(AfkPreventer LANGUAGES CXX)

add_library(AfkPreventer SHARED dllmain.cpp)
set_target_properties(AfkPreventer PROPERTIES
    OUTPUT_NAME AfkPreventer
    PREFIX ""
    SUFFIX ".dll"
)
target_compile_options(AfkPreventer PRIVATE /W3)
set_target_properties(AfkPreventer PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)
