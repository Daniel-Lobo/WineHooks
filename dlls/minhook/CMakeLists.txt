cmake_minimum_required(VERSION 3.10)
project(minhook)
set(CMAKE_CXX_STANDARD 17)

#flags
set (CMAKE_BUILD_TYPE "Release")
set (CMAKE_CXX_FLAGS -fpermissive)
set (CMAKE_CXX_COMPILE_OBJECTS_SEPARATELY ON)
ADD_DEFINITIONS(-DUNICODE)
ADD_DEFINITIONS(-D_WIN32_WINNT=_WIN32_WINNT_WIN7)
    
SET( arch "x64" )
#SET( arch "x86" )

#directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${arch})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${arch})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${arch})

#sources 
set(SRC	${PROJECT_SOURCE_DIR}/src/buffer.c ${PROJECT_SOURCE_DIR}/src/hook.c ${PROJECT_SOURCE_DIR}/src/trampoline.c)
add_library(minhook STATIC ${SRC})
target_include_directories(minhook PRIVATE ${project_dir}/include)
target_include_directories(minhook PRIVATE ${project_dir}/project_dir)