cmake_minimum_required(VERSION 3.10)
project(peixoto)
set(CMAKE_CXX_STANDARD 17)

#flags
set (CMAKE_BUILD_TYPE "Release")
set (CMAKE_CXX_FLAGS -fpermissive)
set (CMAKE_CXX_COMPILE_OBJECTS_SEPARATELY ON)
#set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--output-def")
ADD_DEFINITIONS(-DUNICODE)
ADD_DEFINITIONS(-D_WIN32_WINNT=_WIN32_WINNT_WIN7)

#directories
cmake_path(GET PROJECT_SOURCE_DIR PARENT_PATH Documents_cpp_peixoto) 
cmake_path(GET Documents_cpp_peixoto PARENT_PATH Documents_cpp) 
cmake_path(GET Documents_cpp PARENT_PATH Documents) 
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${Documents_cpp}")

#sources 
set(SRC	
#${Documents_cpp_peixoto}/Sources/CheatEngine.cpp
#${Documents_cpp_peixoto}/Sources/D3D_DDI.cpp
${Documents_cpp_peixoto}/Sources/D3DHooks.cpp
${Documents_cpp_peixoto}/Sources/D3DHooksEx.cpp
${Documents_cpp_peixoto}/Sources/D3DUtils.cpp
${Documents_cpp_peixoto}/Sources/D3D8Hooks.cpp
${Documents_cpp_peixoto}/Sources/D3D9Hooks.cpp
${Documents_cpp_peixoto}/Sources/D3D9Utils.cpp 
${Documents_cpp_peixoto}/Sources/D3D10Hooks.cpp
${Documents_cpp_peixoto}/Sources/D3D10Utils.cpp 
${Documents_cpp_peixoto}/Sources/D3D11Hooks.cpp
${Documents_cpp_peixoto}/Sources/D3D11Utils.cpp 
${Documents_cpp_peixoto}/Sources/D3D12Hooks.cpp
${Documents_cpp_peixoto}/Sources/D3D12Utils.cpp
${Documents_cpp_peixoto}/Sources/DDSurface.c
${Documents_cpp_peixoto}/Sources/DInputHooks.cpp
${Documents_cpp_peixoto}/Sources/Dbug.cpp
${Documents_cpp_peixoto}/Sources/FileSystem.cpp
${Documents_cpp_peixoto}/Sources/FilesSystemHooks.cpp
${Documents_cpp_peixoto}/Sources/GDI_Hooks.cpp
${Documents_cpp_peixoto}/Sources/Input.cpp
${Documents_cpp_peixoto}/Sources/LibVlcPlayer.cpp
#${Documents_cpp_peixoto}/Sources/Proxydll.cpp
${Documents_cpp_peixoto}/Sources/Sync.cpp
${Documents_cpp_peixoto}/Sources/TextureScalers.cpp
${Documents_cpp_peixoto}/Sources/WinMM_Hooks.cpp
${Documents_cpp_peixoto}/Sources/dllmain.cpp   
${Documents_cpp_peixoto}/Sources/sigscan.c
${Documents_cpp_peixoto}/Sources/XInput.cpp   
${Documents_cpp_peixoto}/Sources/collections.cpp
${Documents_cpp_peixoto}/Sources/sethooks.c  
#${Documents_cpp_peixoto}/Sources/virtualdisk.cpp
${Documents_cpp_peixoto}/Sources/MouseHooks.cpp
${Documents_cpp_peixoto}/Sources/CreateprocessHooks.cpp
${Documents_cpp_peixoto}/Sources/DDSurfaceCpp.cpp
${Documents_cpp_peixoto}/Sources/GL_Hooks.cpp
${Documents_cpp_peixoto}/Sources/xbrz.cpp
${Documents_cpp_peixoto}/Sources/Scalers.cpp
${Documents_cpp_peixoto}/Sources/DSoundHooks.cpp 
${Documents_cpp_peixoto}/Sources/Sockets.cpp 
${Documents_cpp_peixoto}/Sources/HTTPSever.cpp
${Documents_cpp_peixoto}/Sources/3DMigoto-Assembler.cpp
#${Documents_cpp_peixoto}/Sources/NVAPISettings.cpp
${Documents_cpp_peixoto}/Sources/Wine.Hooks.cpp
${Documents_cpp_peixoto}/Sources/EZString.cpp
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/DirectDraw.cpp
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/DirectDrawClipper.cpp
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/DirectDrawPalette.cpp
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/DirectDrawSurface.cpp 
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/Direct3DDevice.cpp 
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/Direct3DViewport.cpp 
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/Direct3DVertexBuffer.cpp 
${Documents_cpp_peixoto}/LAYERS/DDRAW/Sources/Direct3DMaterial.cpp 
${Documents_cpp_peixoto}/LAYERS/DINPUT/Sources/DirectInput.cpp
${Documents_cpp_peixoto}/LAYERS/DSOUND/Sources/DirectSound.cpp)

#set(SRC	${Documents_cpp_peixoto}/Sources/Test.cpp)

set(BUILD_SHARED_LIBS ON)
add_library(peixoto SHARED ${SRC})
set_target_properties(peixoto PROPERTIES OUTPUT_NAME "peixoto.dll")
set_target_properties(peixoto PROPERTIES
        PREFIX ""
        SUFFIX ""
        #LINK_FLAGS "-Wl" #,--add-stdcall-alias --output-def peixoto.def"
        #POSITION_INDEPENDENT_CODE 0 # this is to avoid MinGW warning; 
        # MinGW generates position-independent-code for DLL by default
)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/Headers)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/Includes)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/Includes/cpp-httplib)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/Includes/nvapi)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/Includes/DX8SDK)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/Includes/EAX)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/LAYERS)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/LAYERS/DDRAW/Headers)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/LAYERS/DINPUT/Headers)
target_include_directories(peixoto PRIVATE ${Documents_cpp_peixoto}/LAYERS/DSOUND/Headers)
if (WIN32)
    target_include_directories(peixoto PRIVATE "${Documents}/Visual Studio 2015/Projects/minhook/include")
    target_include_directories(peixoto PRIVATE "${Documents}/AutoHotkey/Lib/DirectX/AHK Injector/Shaders/FSR_1_0")
    target_include_directories(peixoto PRIVATE "C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/um")
    target_include_directories(peixoto PRIVATE "C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/shared")
    target_include_directories(peixoto PRIVATE "C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/ucrt")
else()
    target_include_directories(peixoto PRIVATE "${Documents_cpp_peixoto}/minhook/include")
    target_include_directories(peixoto PRIVATE "${Documents_cpp}/Shaders/FSR_1_0")
    target_include_directories(peixoto PRIVATE "/usr/i686-w64-mingw32/include")  
endif()    

if (WIN32)
    link_directories("C:/Program Files (x86)/Windows Kits/10/Lib/10.0.17134.0/um/x86/")
    SET(LIBS d3d9 dxguid dinput8 Xinput advapi32 Kernel32 Ole32 Shell32 OleAut32 Winmm Psapi User32 Gdi32 Shlwapi opengl32 Ws2_32 Pathcch)
    target_link_libraries(peixoto ${LIBS})
    target_link_libraries(peixoto "${Documents_cpp_peixoto}/Includes/nvapi/lib/nvapi.lib")
    target_link_libraries(peixoto "${Documents_cpp}/Visual Studio 2015/Projects/minhook/build/VC14/lib/Release/libMinHook.x86.lib")
else()
    link_directories("/usr/i686-w64-mingw32/lib")
    SET(LIBS d3d9 dxguid dinput8 xinput advapi32 kernel32 ole32 shell32 oleaut32 winmm psapi user32 gdi32 shlwapi opengl32 ws2_32 pathcch)
    target_link_libraries(peixoto ${LIBS})
    #target_link_libraries(peixoto "${Documents_cpp_peixoto}/Includes/nvapi/lib/nvapi.lib")
    target_link_libraries(peixoto "${Documents_cpp_peixoto}/minhook/build/VC14/lib/Release/libMinHook.x86.lib")
endif()    