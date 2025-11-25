@echo off
echo Configurazione ambiente Java per il progetto Android...

REM Cerca Java nelle posizioni comuni
set JAVA_PATHS[0]="C:\Program Files\Java\jdk-21\bin\java.exe"
set JAVA_PATHS[1]="C:\Program Files\Java\jdk-17\bin\java.exe"
set JAVA_PATHS[2]="C:\Program Files\Java\jdk-11\bin\java.exe"
set JAVA_PATHS[3]="C:\Program Files\Eclipse Adoptium\jdk-21.0.1.12-hotspot\bin\java.exe"
set JAVA_PATHS[4]="C:\Program Files\Eclipse Adoptium\jdk-17.0.9.9-hotspot\bin\java.exe"
set JAVA_PATHS[5]="C:\Program Files\Eclipse Adoptium\jdk-11.0.21.9-hotspot\bin\java.exe"
set JAVA_PATHS[6]="C:\Program Files\OpenJDK\jdk-21\bin\java.exe"
set JAVA_PATHS[7]="C:\Program Files\OpenJDK\jdk-17\bin\java.exe"
set JAVA_PATHS[8]="C:\Program Files\OpenJDK\jdk-11\bin\java.exe"

echo Cercando installazioni Java...

for /L %%i in (0,1,8) do (
    call set "JAVA_PATH=%%JAVA_PATHS[%%i]%%"
    if exist !JAVA_PATH! (
        echo Trovato Java: !JAVA_PATH!
        for /f "tokens=*" %%a in ('!JAVA_PATH! -version 2^>^&1') do echo %%a
        set "JAVA_HOME=!JAVA_PATH:~0,-10!"
        echo JAVA_HOME impostato a: !JAVA_HOME!
        goto :found
    )
)

echo ERRORE: Nessuna installazione Java trovata!
echo Per favore installa Java 11, 17 o 21 e riprova.
pause
exit /b 1

:found
echo.
echo Ambiente Java configurato correttamente!
echo Ora puoi eseguire: .\gradlew build
pause




