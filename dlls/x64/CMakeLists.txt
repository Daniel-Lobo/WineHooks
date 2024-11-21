cmake_minimum_required(VERSION 3.10)
project(peixoto64)
set(CMAKE_CXX_STANDARD 17)

#flags
set (CMAKE_BUILD_TYPE "Release")
set (CMAKE_CXX_FLAGS "/Zc:strictStrings-")
set (CMAKE_C_FLAGS "/Zc:strictStrings-")
ADD_DEFINITIONS(-DUNICODE)
ADD_DEFINITIONS(-D_WIN32_WINNT=_WIN32_WINNT_WIN7)

#directories
cmake_path(GET PROJECT_SOURCE_DIR PARENT_PATH Documents_cpp_peixoto) 
cmake_path(GET Documents_cpp_peixoto PARENT_PATH Documents_cpp) 
cmake_path(GET Documents_cpp PARENT_PATH Documents) 
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${Documents}/AutoHotkey/Lib/DirectX/AHK Injector")

#sources 
set(SRC	
${Documents_cpp_peixoto}/Sources/dllmain.cpp
${Documents_cpp_peixoto}/Sources/CheatEngine.cpp
${Documents_cpp_peixoto}/Sources/D3D11Hooks.cpp 
${Documents_cpp_peixoto}/Sources/D3D11Utils.cpp
${Documents_cpp_peixoto}/Sources/D3D12Hooks.cpp
${Documents_cpp_peixoto}/Sources/D3D12Utils.cpp
${Documents_cpp_peixoto}/Sources/DDSurfaceCpp.cpp
${Documents_cpp_peixoto}/Sources/Dbug.cpp 
${Documents_cpp_peixoto}/Sources/FileSystem.cpp
${Documents_cpp_peixoto}/Sources/FilesSystemHooks.cpp
${Documents_cpp_peixoto}/Sources/GDI_Hooks.cpp
${Documents_cpp_peixoto}/Sources/MouseHooks.cpp
${Documents_cpp_peixoto}/Sources/Scalers.cpp
${Documents_cpp_peixoto}/Sources/Sync.cpp
${Documents_cpp_peixoto}/Sources/TextureScalers.cpp
${Documents_cpp_peixoto}/Sources/collections.cpp
${Documents_cpp_peixoto}/Sources/sigscan.c 
${Documents_cpp_peixoto}/Sources/sethooks.c
${Documents_cpp_peixoto}/Sources/dllmain.cpp
${Documents_cpp_peixoto}/Sources/DDSurface.c
${Documents_cpp_peixoto}/Sources/GL_Hooks.cpp
${Documents_cpp_peixoto}/Sources/xbrz.cpp
${Documents_cpp_peixoto}/Sources/3DMigoto-Assembler.cpp
${Documents_cpp_peixoto}/Sources/NVAPISettings.cpp
${Documents_cpp_peixoto}/Sources/Wine.Hooks.cpp
${Documents_cpp_peixoto}/Sources/EZString.cpp)

add_library(peixoto64 SHARED ${SRC})
target_include_directories(peixoto64 PRIVATE ${Documents_cpp_peixoto}/Headers)
target_include_directories(peixoto64 PRIVATE ${Documents_cpp_peixoto}/Includes)
target_include_directories(peixoto64 PRIVATE ${Documents_cpp_peixoto}/Includes/nvapi)
target_include_directories(peixoto64 PRIVATE ${Documents_cpp_peixoto}/LAYERS)
target_include_directories(peixoto64 PRIVATE ${Documents_cpp_peixoto}/LAYERS/DDRAW/Headers)
target_include_directories(peixoto64 PRIVATE "${Documents}/Visual Studio 2015/Projects/minhook/include")
target_include_directories(peixoto64 PRIVATE "${Documents}/AutoHotkey/Lib/DirectX/AHK Injector/Shaders/FSR_1_0")
target_include_directories(peixoto64 PRIVATE "C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/um")
target_include_directories(peixoto64 PRIVATE "C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/shared")
target_include_directories(peixoto64 PRIVATE "C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/ucrt")

SET(LIBS d3d9 Ole32 User32 Gdi32 Shlwapi opengl32 Pathcch)
target_link_libraries(peixoto64 ${LIBS})
target_link_libraries(peixoto64 "${Documents_cpp_peixoto}/Includes/nvapi/lib/nvapi64.lib")
target_link_libraries(peixoto64 "${Documents}/Visual Studio 2015/Projects/minhook/build/VC14/lib/Release/libMinHook.x64.lib")
target_link_libraries(peixoto64 "${Documents}/Visual Studio 2015/Projects/minhook/build/VC14/bin/Release/MinHook.x64.lib")