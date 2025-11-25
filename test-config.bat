@echo off
echo ========================================
echo    Test Configurazione Gradle
echo ========================================
echo.

echo Verifica file di configurazione...
echo.

echo 1. Controllo build.gradle...
findstr /C:"allprojects" build.gradle
if %ERRORLEVEL% equ 0 (
    echo ERRORE: allprojects repository trovati in build.gradle!
    echo Dovrebbero essere solo in settings.gradle
) else (
    echo OK: Nessun allprojects repository in build.gradle
)

findstr /C:"buildscript" build.gradle
if %ERRORLEVEL% equ 0 (
    echo OK: buildscript repository configurato correttamente
) else (
    echo ERRORE: buildscript repository mancante!
)

echo.
echo 2. Controllo settings.gradle...
findstr /C:"google()" settings.gradle
if %ERRORLEVEL% equ 0 (
    echo OK: Google repository trovato in settings.gradle
) else (
    echo ERRORE: Google repository mancante in settings.gradle!
)

findstr /C:"mavenCentral()" settings.gradle
if %ERRORLEVEL% equ 0 (
    echo OK: MavenCentral repository trovato in settings.gradle
) else (
    echo ERRORE: MavenCentral repository mancante in settings.gradle!
)

findstr /C:"maven.sumup.com" settings.gradle
if %ERRORLEVEL% equ 0 (
    echo OK: SumUp repository trovato in settings.gradle
) else (
    echo ERRORE: SumUp repository mancante in settings.gradle!
)

echo.
echo 3. Controllo versione Gradle...
findstr /C:"gradle-8.5" gradle\wrapper\gradle-wrapper.properties
if %ERRORLEVEL% equ 0 (
    echo OK: Gradle 8.5 configurato
) else (
    echo ERRORE: Gradle 8.5 non configurato!
)

echo.
echo 4. Controllo Android Gradle Plugin...
findstr /C:"gradle:8.2.0" build.gradle
if %ERRORLEVEL% equ 0 (
    echo OK: Android Gradle Plugin 8.2.0 configurato
) else (
    echo ERRORE: Android Gradle Plugin non configurato correttamente!
)

echo.
echo ========================================
echo    Test Completato
echo ========================================
echo.
echo Se tutti i controlli mostrano "OK", la configurazione è corretta.
echo Puoi ora aprire il progetto in Android Studio.
echo.
pause
