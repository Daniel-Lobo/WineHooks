cmake_minimum_required(VERSION 3.10)
project(peixoto)
set(CMAKE_CXX_STANDARD 17)

#flags
set (CMAKE_BUILD_TYPE "Release")
set (CMAKE_CXX_FLAGS "-fpermissive -static")
set (CMAKE_CXX_COMPILE_OBJECTS_SEPARATELY ON)
ADD_DEFINITIONS(-DUNICODE)
ADD_DEFINITIONS(-D_WIN32_WINNT=_WIN32_WINNT_WIN7)

SET(arch "x64")
#SET(arch "x86")
SET(MinGW "/usr/i686-w64-mingw32")
SET(MinGW_MS "c:/MinGW/mingw32/i686-w64-mingw32")
SET(MInHook "x32/libminhook.a")

if (arch STREQUAL "x64")
    SET(MinGW "/usr/x86_64-w64-mingw32")
    SET(MinGW_MS "c:/MinGW/mingw64/x86_64-w64-mingw32")
    SET(MInHook "x64/libminhook.a")
endif()

#directories
cmake_path(GET PROJECT_SOURCE_DIR PARENT_PATH parent_dir) 
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY  "${parent_dir}/Ahk")

MESSAGE(${parent_dir})

#sources 
set(SRC32	
#${PROJECT_SOURCE_DIR}/Sources/CheatEngine.cpp
${PROJECT_SOURCE_DIR}/Sources/D3DHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3DHooksEx.cpp
${PROJECT_SOURCE_DIR}/Sources/D3DUtils.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D8Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D9Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D9Utils.cpp 
${PROJECT_SOURCE_DIR}/Sources/D3D10Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D10Utils.cpp 
${PROJECT_SOURCE_DIR}/Sources/D3D11Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D11Utils.cpp 
${PROJECT_SOURCE_DIR}/Sources/D3D12Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D12Utils.cpp
${PROJECT_SOURCE_DIR}/Sources/DDSurface.c
${PROJECT_SOURCE_DIR}/Sources/DInputHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/Dbug.cpp
${PROJECT_SOURCE_DIR}/Sources/FileSystem.cpp
${PROJECT_SOURCE_DIR}/Sources/FilesSystemHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/GDI_Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/Input.cpp
${PROJECT_SOURCE_DIR}/Sources/LibVlcPlayer.cpp
${PROJECT_SOURCE_DIR}/Sources/Proxydll.cpp
${PROJECT_SOURCE_DIR}/Sources/Sync.cpp
${PROJECT_SOURCE_DIR}/Sources/TextureScalers.cpp
${PROJECT_SOURCE_DIR}/Sources/WinMM_Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/dllmain.cpp   
${PROJECT_SOURCE_DIR}/Sources/sigscan.c
${PROJECT_SOURCE_DIR}/Sources/XInput.cpp   
${PROJECT_SOURCE_DIR}/Sources/collections.cpp
${PROJECT_SOURCE_DIR}/Sources/sethooks.c  
#${PROJECT_SOURCE_DIR}/Sources/virtualdisk.cpp
${PROJECT_SOURCE_DIR}/Sources/MouseHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/CreateprocessHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/DDSurfaceCpp.cpp
${PROJECT_SOURCE_DIR}/Sources/GL_Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/xbrz.cpp
${PROJECT_SOURCE_DIR}/Sources/Scalers.cpp
${PROJECT_SOURCE_DIR}/Sources/DSoundHooks.cpp 
${PROJECT_SOURCE_DIR}/Sources/Sockets.cpp 
${PROJECT_SOURCE_DIR}/Sources/HTTPSever.cpp
${PROJECT_SOURCE_DIR}/Sources/3DMigoto-Assembler.cpp
#${PROJECT_SOURCE_DIR}/Sources/NVAPISettings.cpp
${PROJECT_SOURCE_DIR}/Sources/Wine.Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/EZString.cpp
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/DirectDraw.cpp
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/DirectDrawClipper.cpp
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/DirectDrawPalette.cpp
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/DirectDrawSurface.cpp 
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/Direct3DDevice.cpp 
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/Direct3DViewport.cpp 
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/Direct3DVertexBuffer.cpp 
${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Sources/Direct3DMaterial.cpp 
${PROJECT_SOURCE_DIR}/LAYERS/DINPUT/Sources/DirectInput.cpp
${PROJECT_SOURCE_DIR}/LAYERS/DSOUND/Sources/DirectSound.cpp)

set(SRC64	
${PROJECT_SOURCE_DIR}/Sources/dllmain.cpp
#${PROJECT_SOURCE_DIR}/Sources/CheatEngine.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D11Hooks.cpp 
${PROJECT_SOURCE_DIR}/Sources/D3D11Utils.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D12Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/D3D12Utils.cpp
${PROJECT_SOURCE_DIR}/Sources/DDSurfaceCpp.cpp
${PROJECT_SOURCE_DIR}/Sources/Dbug.cpp 
${PROJECT_SOURCE_DIR}/Sources/FileSystem.cpp
${PROJECT_SOURCE_DIR}/Sources/FilesSystemHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/GDI_Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/MouseHooks.cpp
${PROJECT_SOURCE_DIR}/Sources/Scalers.cpp
${PROJECT_SOURCE_DIR}/Sources/Sync.cpp
${PROJECT_SOURCE_DIR}/Sources/TextureScalers.cpp
${PROJECT_SOURCE_DIR}/Sources/collections.cpp
${PROJECT_SOURCE_DIR}/Sources/sigscan.c 
${PROJECT_SOURCE_DIR}/Sources/sethooks.c
${PROJECT_SOURCE_DIR}/Sources/dllmain.cpp
${PROJECT_SOURCE_DIR}/Sources/DDSurface.c
${PROJECT_SOURCE_DIR}/Sources/GL_Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/xbrz.cpp
${PROJECT_SOURCE_DIR}/Sources/3DMigoto-Assembler.cpp
#${PROJECT_SOURCE_DIR}/Sources/NVAPISettings.cpp
${PROJECT_SOURCE_DIR}/Sources/Wine.Hooks.cpp
${PROJECT_SOURCE_DIR}/Sources/EZString.cpp)

#set(SRC32	${PROJECT_SOURCE_DIR}/Sources/Test.cpp)
#set(SRC64	${PROJECT_SOURCE_DIR}/Sources/Test.cpp)

set(BUILD_SHARED_LIBS ON)
if (arch STREQUAL "x86")
    add_library(peixoto SHARED ${SRC32})
    set_target_properties(peixoto PROPERTIES OUTPUT_NAME "peixoto.dll")
    set_target_properties(peixoto PROPERTIES
            PREFIX ""
            SUFFIX ""       
            LINK_FLAGS "--def DEF_FILE ${PROJECT_SOURCE_DIR}/peixoto.def"  
    )
else()
    add_library(peixoto SHARED ${SRC64})
    set_target_properties(peixoto PROPERTIES OUTPUT_NAME "peixoto64.dll")
    set_target_properties(peixoto PROPERTIES
            PREFIX ""
            SUFFIX ""       
            #LINK_FLAGS "--def DEF_FILE ${PROJECT_SOURCE_DIR}/peixoto.def"  
    )
endif()

target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/Headers)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/Includes)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/Includes/cpp-httplib)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/Includes/nvapi)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/Includes/DX8SDK)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/Includes/EAX)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/LAYERS)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/LAYERS/DDRAW/Headers)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/LAYERS/DINPUT/Headers)
target_include_directories(peixoto PRIVATE ${PROJECT_SOURCE_DIR}/LAYERS/DSOUND/Headers)
target_include_directories(peixoto PRIVATE ${parent_dir}/Shaders/FSR_1_0/) 

if (WIN32)
    target_include_directories(peixoto PRIVATE "${PROJECT_SOURCE_DIR}/minhook/include")
    target_include_directories(peixoto PRIVATE "${Documents_cpp}/Shaders/FSR_1_0")
    target_include_directories(peixoto PRIVATE "${MinGW_MS}/include")     
else()
    target_include_directories(peixoto PRIVATE "${PROJECT_SOURCE_DIR}/minhook/include")
    target_include_directories(peixoto PRIVATE "${Documents_cpp}/Shaders/FSR_1_0")
    target_include_directories(peixoto PRIVATE "${MinGW}/include")  
endif()    

if (WIN32)
    link_directories("/${MinGW_MS}/lib")
    SET(LIBS d3d9 dxguid dinput8 Xinput advapi32 Kernel32 Ole32 Shell32 OleAut32 Winmm Psapi User32 Gdi32 Shlwapi opengl32 Ws2_32 Pathcch uuid)
    target_link_libraries(peixoto ${LIBS})
    #target_link_libraries(peixoto "${PROJECT_SOURCE_DIR}/Includes/nvapi/lib/nvapi.lib")
    target_link_libraries(peixoto "${PROJECT_SOURCE_DIR}/minhook/build/${MInHook}")
else()
    link_directories("/${MinGW}/lib")
    SET(LIBS d3d9 dxguid dinput8 xinput advapi32 kernel32 ole32 shell32 oleaut32 winmm psapi user32 gdi32 shlwapi opengl32 ws2_32 pathcch uuid)
    target_link_libraries(peixoto ${LIBS})    
    target_link_libraries(peixoto "${PROJECT_SOURCE_DIR}/minhook/build/${MInHook}")
endif()