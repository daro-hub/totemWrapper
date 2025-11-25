# SumUp Payment App

Un'app Android che integra i pagamenti SumUp per effettuare transazioni.

## Funzionalità

- ✅ Integrazione completa con SumUp Merchant API
- ✅ Interfaccia utente semplice e intuitiva
- ✅ Gestione completa dei risultati di pagamento
- ✅ Supporto per metadati personalizzati
- ✅ Gestione degli errori e stati di pagamento

## Configurazione

### 1. Chiave Affiliato

Prima di utilizzare l'app, devi configurare la tua chiave affiliato SumUp:

1. Vai su [https://me.sumup.com/developers](https://me.sumup.com/developers)
2. Inserisci l'ID dell'applicazione: `com.example.sumuppaymentapp`
3. Ottieni la tua chiave affiliato
4. Sostituisci `YOUR_AFFILIATE_KEY` nel file `MainActivity.kt` con la tua chiave

### 2. Installazione SumUp

L'app richiede che l'app SumUp sia installata sul dispositivo per funzionare.

## Struttura del Progetto

```
app/
├── src/main/
│   ├── java/com/example/sumuppaymentapp/
│   │   └── MainActivity.kt          # Logica principale dell'app
│   ├── res/
│   │   ├── layout/
│   │   │   └── activity_main.xml    # Layout dell'interfaccia
│   │   ├── values/
│   │   │   ├── strings.xml          # Stringhe localizzate
│   │   │   ├── colors.xml           # Colori dell'app
│   │   │   └── themes.xml           # Temi Material Design
│   │   └── xml/
│   │       ├── backup_rules.xml
│   │       └── data_extraction_rules.xml
│   └── AndroidManifest.xml          # Manifest dell'app
├── build.gradle                     # Configurazione Gradle dell'app
└── proguard-rules.pro              # Regole ProGuard
```

## Dipendenze

- **SumUp Merchant API**: `com.sumup:merchant-api:1.4.0`
- **AndroidX Core**: `androidx.core:core-ktx:1.12.0`
- **Material Design**: `com.google.android.material:material:1.11.0`

## Utilizzo

1. **Avvio Pagamento**: Tocca il pulsante "Effettua Pagamento"
2. **Configurazione**: L'app crea automaticamente un pagamento di €1.23
3. **Risultato**: L'app gestisce automaticamente il risultato del pagamento

## Gestione Risultati

L'app gestisce tutti i possibili risultati del pagamento:

- ✅ **Successo**: Pagamento completato con successo
- ❌ **Errore**: Errore durante il pagamento
- 🚫 **Annullato**: Pagamento annullato dall'utente

## Personalizzazione

### Modificare l'Importo

Per cambiare l'importo del pagamento, modifica il valore in `MainActivity.kt`:

```kotlin
.total(BigDecimal("1.23"))  // Cambia questo valore
```

### Aggiungere Metadati

Puoi aggiungere metadati personalizzati al pagamento:

```kotlin
.addAdditionalInfo("Chiave", "Valore")
```

### Modificare i Dettagli

Personalizza i dettagli del pagamento:

```kotlin
.title("Il tuo titolo personalizzato")
.receiptEmail("email@example.com")
.receiptSMS("+393401234567")
```

## Build e Deploy

### Opzione 1: Android Studio (Raccomandato)
1. Apri il progetto in Android Studio
2. Sincronizza il progetto con i file Gradle
3. Configura la chiave affiliato
4. Builda e installa l'APK sul dispositivo

### Opzione 2: Command Line
1. **Installa Java 11, 17 o 21** se non l'hai già fatto
2. **Esegui il build script:**
   ```bash
   .\build-project.bat
   ```
3. **Se hai errori di build, usa il fix script:**
   ```bash
   .\fix-build.bat
   ```
4. **Oppure manualmente:**
   ```bash
   # Configura JAVA_HOME (sostituisci con il tuo percorso Java)
   set JAVA_HOME=C:\Program Files\Java\jdk-21
   
   # Pulisci e builda (senza configuration cache)
   .\gradlew clean --no-configuration-cache
   .\gradlew assembleDebug --no-configuration-cache
   ```

### Risoluzione Problemi Comuni

**Errore Configuration Cache:**
- Il progetto è configurato per disabilitare il configuration cache
- Se hai ancora problemi, esegui `.\fix-build.bat`

**Errore JDK Image:**
- Usa `--no-configuration-cache` nelle build
- Apri il progetto in Android Studio per una build più stabile

### Requisiti di Sistema
- **Java**: 11, 17 o 21 (raccomandato 21)
- **Android SDK**: API Level 21+ (Android 5.0+)
- **Gradle**: 8.5+ (configurato automaticamente)

## Note Importanti

- Assicurati che SumUp sia installato sul dispositivo
- La chiave affiliato deve essere valida e configurata correttamente
- L'app richiede permessi di rete per comunicare con i server SumUp

## Supporto

Per problemi con l'integrazione SumUp, consulta la [documentazione ufficiale](https://developer.sumup.com/).
