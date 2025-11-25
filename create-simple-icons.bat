@echo off
echo ========================================
echo    Creazione Icone App SumUp
echo ========================================
echo.

echo Creazione icone semplici per l'app SumUp Payment...
echo.

REM Crea icone PNG semplici usando PowerShell
powershell -Command "
# Crea un'icona PNG semplice con PowerShell
Add-Type -AssemblyName System.Drawing

# Funzione per creare un'icona
function Create-Icon {
    param([string]$outputPath, [int]$size)
    
    # Crea un bitmap
    $bitmap = New-Object System.Drawing.Bitmap($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Sfondo viola
    $graphics.Clear([System.Drawing.Color]::FromArgb(98, 0, 238))
    
    # Crea un pennello bianco
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $purpleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(98, 0, 238))
    
    # Disegna un cerchio (simbolo di moneta)
    $circleSize = [int]($size * 0.3)
    $circleX = [int](($size - $circleSize) / 2)
    $circleY = [int](($size - $circleSize) / 2) - [int]($size * 0.1)
    $graphics.FillEllipse($whiteBrush, $circleX, $circleY, $circleSize, $circleSize)
    
    # Disegna un rettangolo (simbolo di carta)
    $rectWidth = [int]($size * 0.6)
    $rectHeight = [int]($size * 0.25)
    $rectX = [int](($size - $rectWidth) / 2)
    $rectY = [int]($size * 0.6)
    $graphics.FillRectangle($whiteBrush, $rectX, $rectY, $rectWidth, $rectHeight)
    
    # Aggiungi il simbolo €
    $font = New-Object System.Drawing.Font('Arial', [int]($size * 0.15), [System.Drawing.FontStyle]::Bold)
    $textSize = $graphics.MeasureString('€', $font)
    $textX = [int](($size - $textSize.Width) / 2)
    $textY = [int]($rectY + ($rectHeight - $textSize.Height) / 2)
    $graphics.DrawString('€', $font, $purpleBrush, $textX, $textY)
    
    # Salva l'icona
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Pulisci
    $graphics.Dispose()
    $bitmap.Dispose()
    $whiteBrush.Dispose()
    $purpleBrush.Dispose()
    $font.Dispose()
}

# Crea icone per diverse densità
$densities = @{
    'mipmap-mdpi' = 48
    'mipmap-hdpi' = 72
    'mipmap-xhdpi' = 96
    'mipmap-xxhdpi' = 144
    'mipmap-xxxhdpi' = 192
}

foreach ($density in $densities.Keys) {
    $size = $densities[$density]
    Create-Icon \"app\src\main\res\$density\ic_launcher.png\" $size
    Create-Icon \"app\src\main\res\$density\ic_launcher_round.png\" $size
    Write-Host \"Icone create per $density ($size px)\"
}

Write-Host \"Tutte le icone sono state create con successo!\"
"

echo.
echo ========================================
echo    ICONE CREATE CON SUCCESSO!
echo ========================================
echo.
echo Le icone sono state create per tutte le densità.
echo Ora puoi buildare l'app!
echo.
pause







