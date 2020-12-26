
cmake_minimum_required(VERSION 3.19)

project("CMake C-style mock generation example")

include(../CMakeFile.cmake)

add_c_mock(example_mock example_mock.json)