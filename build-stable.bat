@echo off
echo ========================================
echo    BUILD STABLE - SumUp Payment App
echo ========================================
echo.

REM Verifica JAVA_HOME
if "%JAVA_HOME%"=="" (
    echo [ERRORE] JAVA_HOME non configurato!
    echo.
    echo Configurazione automatica JAVA_HOME...
    call setup-java.bat
    if errorlevel 1 (
        echo [ERRORE] Impossibile configurare JAVA_HOME automaticamente
        echo Configura manualmente JAVA_HOME e riprova
        pause
        exit /b 1
    )
)

echo [INFO] JAVA_HOME: %JAVA_HOME%
echo.

REM Pulisci cache Gradle
echo [INFO] Pulizia cache Gradle...
if exist "%USERPROFILE%\.gradle\caches" (
    rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
    echo [OK] Cache Gradle pulita
) else (
    echo [INFO] Cache Gradle già pulita
)

REM Pulisci build locale
echo [INFO] Pulizia build locale...
if exist "build" (
    rmdir /s /q "build" 2>nul
    echo [OK] Build locale pulita
)
if exist "app\build" (
    rmdir /s /q "app\build" 2>nul
    echo [OK] Build app pulita
)

echo.
echo [INFO] Avvio build con configurazioni stabili...
echo.

REM Build con configurazioni stabili
gradle clean assembleDebug --no-configuration-cache --no-daemon --no-parallel --stacktrace

if errorlevel 1 (
    echo.
    echo [ERRORE] Build fallita!
    echo.
    echo Soluzioni possibili:
    echo 1. Verifica che JAVA_HOME punti a Java 11 o 17
    echo 2. Riavvia Android Studio
    echo 3. Prova con Java 17 invece di Java 21
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo [SUCCESSO] Build completata!
    echo.
    echo APK generato in: app\build\outputs\apk\debug\
    echo.
    pause
)







