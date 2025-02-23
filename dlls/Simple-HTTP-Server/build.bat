@echo off

IF not exist bin (
    mkdir bin
) else (
    rm -r bin
    mkdir bin
)

REM compile
g++ -o bin/server.exe ./*.cpp -lws2_32

REM run if flag exist
IF "%1"=="-r" (
    IF exist bin/server.exe (
        IF "%2"=="-p" (
            for /f "delims=0123456789" %%a in ("%3") do (
                echo Invalid port number: %3
                exit /b 1
            )
            start bin/server.exe "%2" "%3"
        ) else (
            start bin/server.exe
        )
    )
)