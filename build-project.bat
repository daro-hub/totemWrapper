@echo off
echo ========================================
echo    SumUp Payment App - Build Script
echo ========================================
echo.

REM Cerca Java nelle posizioni comuni
echo Cercando installazioni Java...

set "JAVA_FOUND=0"

REM Cerca Java 21
for /d %%i in ("C:\Program Files\Java\jdk-21*") do (
    if exist "%%i\bin\java.exe" (
        set "JAVA_HOME=%%i"
        set "JAVA_FOUND=1"
        echo Trovato Java 21: %%i
        goto :found
    )
)

REM Cerca Java 17
for /d %%i in ("C:\Program Files\Java\jdk-17*") do (
    if exist "%%i\bin\java.exe" (
        set "JAVA_HOME=%%i"
        set "JAVA_FOUND=1"
        echo Trovato Java 17: %%i
        goto :found
    )
)

REM Cerca Java 11
for /d %%i in ("C:\Program Files\Java\jdk-11*") do (
    if exist "%%i\bin\java.exe" (
        set "JAVA_HOME=%%i"
        set "JAVA_FOUND=1"
        echo Trovato Java 11: %%i
        goto :found
    )
)

REM Cerca Eclipse Adoptium
for /d %%i in ("C:\Program Files\Eclipse Adoptium\jdk-*") do (
    if exist "%%i\bin\java.exe" (
        set "JAVA_HOME=%%i"
        set "JAVA_FOUND=1"
        echo Trovato Eclipse Adoptium: %%i
        goto :found
    )
)

REM Cerca OpenJDK
for /d %%i in ("C:\Program Files\OpenJDK\jdk-*") do (
    if exist "%%i\bin\java.exe" (
        set "JAVA_HOME=%%i"
        set "JAVA_FOUND=1"
        echo Trovato OpenJDK: %%i
        goto :found
    )
)

if %JAVA_FOUND%==0 (
    echo.
    echo ERRORE: Nessuna installazione Java trovata!
    echo.
    echo Per favore installa una delle seguenti versioni:
    echo - Java 11, 17 o 21
    echo - Eclipse Adoptium
    echo - OpenJDK
    echo.
    echo Puoi scaricare Java da: https://adoptium.net/
    echo.
    pause
    exit /b 1
)

:found
echo.
echo JAVA_HOME impostato a: %JAVA_HOME%
echo.

REM Aggiungi Java al PATH per questa sessione
set "PATH=%JAVA_HOME%\bin;%PATH%"

REM Verifica la versione Java
echo Verifica versione Java:
java -version
echo.

REM Pulisci e builda il progetto
echo ========================================
echo    Pulizia e Build del Progetto
echo ========================================
echo.

echo 1. Pulizia progetto...
call .\gradlew clean
if %ERRORLEVEL% neq 0 (
    echo ERRORE durante la pulizia!
    pause
    exit /b 1
)

echo.
echo 2. Build progetto...
call .\gradlew build
if %ERRORLEVEL% neq 0 (
    echo ERRORE durante la build!
    pause
    exit /b 1
)

echo.
echo ========================================
echo    BUILD COMPLETATA CON SUCCESSO!
echo ========================================
echo.
echo Il progetto è stato compilato correttamente.
echo Puoi ora aprire il progetto in Android Studio.
echo.
pause







