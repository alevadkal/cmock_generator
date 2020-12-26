
# MIT License

# Copyright (c) 2020 alevadkal

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set_property(DIRECTORY 
    APPEND 
    PROPERTY CMAKE_CONFIGURE_DEPENDS 
    ${CMAKE_CURRENT_LIST_DIR}/generator.py
)

set(MOCK_GENERATOR_C_SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR})

macro(add_c_mock name config)
    # Run code generation on configuration step
    message("-- Generate mock ${name} from ${CMAKE_CURRENT_SOURCE_DIR}/${config}")
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${name})
    execute_process(
        COMMAND 
            ${MOCK_GENERATOR_C_SOURCE_DIR}/generator.py ${name} ${CMAKE_CURRENT_SOURCE_DIR}/${config}
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_BINARY_DIR}/${name}
        RESULT_VARIABLE
            MOCK_GENERATOR_C_CONFIG_STATUS
    )
    
    #Check status of generation and report message if something going wrong
    if(NOT MOCK_GENERATOR_C_CONFIG_STATUS EQUAL 0)
        message(
            FATAL_ERROR 
            "-- Mock generator for ${name} return error for '${CMAKE_CURRENT_SOURCE_DIR}/${config}'"
        )
    endif()
    
    #Add generated CMakeLists.txt to project
    add_subdirectory(
        ${CMAKE_CURRENT_BINARY_DIR}/${name}
        ${CMAKE_CURRENT_BINARY_DIR}/${name}/binary
    )

    # Is some of generated files or config changed, then project regeneration requared.
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${name}/CMakeLists.txt)
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${name}/include/${name}.hpp)
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${name}/src/${name}.cpp)
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${config})
endmacro()

