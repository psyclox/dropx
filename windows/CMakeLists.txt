cmake_minimum_required(VERSION 3.14)
project(dropx LANGUAGES CXX)

set(BINARY_NAME "dropx")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Configure build options.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Configuration type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Directory containing the Flutter engine and plug-in wrapper code.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Include the wrapper targets.
add_subdirectory("${FLUTTER_MANAGED_DIR}")

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")

# Generated plugin build.
set(FLUTTER_PLUGIN_LIST_FILE "${CMAKE_CURRENT_BINARY_DIR}/flutter/generated_plugins.cmake")
if(EXISTS "${FLUTTER_PLUGIN_LIST_FILE}")
  include("${FLUTTER_PLUGIN_LIST_FILE}")
endif()
