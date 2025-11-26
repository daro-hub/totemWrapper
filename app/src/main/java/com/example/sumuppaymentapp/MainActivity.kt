package com.example.sumuppaymentapp

import android.app.Activity
import android.app.AlertDialog
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import android.view.WindowManager
import android.webkit.JavascriptInterface
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.TextView
import androidx.appcompat.widget.SwitchCompat
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.example.sumuppaymentapp.databinding.ActivityMainBinding
import com.google.gson.Gson
import com.sumup.merchant.api.SumUpAPI
import com.sumup.merchant.api.SumUpPayment
import java.math.BigDecimal
import java.util.*

// Data class per i dati di pagamento ricevuti dalla webapp
data class PaymentData(
    val totalPrice: Double,    // Prezzo totale del pagamento
    val quantity: Int,         // Quantità di biglietti
    val museumId: String,      // ID del museo
    val timestamp: Long        // Timestamp del pagamento
)

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    
    // Chiave affiliato SumUp - SOSTITUIRE CON LA VOSTRA CHIAVE
    private val AFFILIATE_KEY = "sup_afk_zQ4j4OTduBWxUO7g32DQkVkfdgurbTQy"

    // Gson per il parsing JSON
    private val gson = Gson()
    
    // Dati di pagamento ricevuti dalla webapp
    private var currentPaymentData: PaymentData? = null
    
    // Request code per il pagamento
    private val PAYMENT_REQUEST_CODE = 1
    
    // Gestione modalità app
    private lateinit var sharedPreferences: SharedPreferences
    private var isActiveMode: Boolean = true // true = active (pagamenti funzionanti), false = test (pagamenti disconnessi)
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Hide status bar and navigation bar for fullscreen experience
        hideSystemUI()
        
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Inizializza SharedPreferences
        sharedPreferences = getSharedPreferences("app_settings", MODE_PRIVATE)
        isActiveMode = sharedPreferences.getBoolean("active_mode", true) // Default: active mode

        setupWebView()
        setupUI()
    }
    
    private fun hideSystemUI() {
        // Keep screen on
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        
        // Hide the status bar and navigation bar using modern API
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Android 11+ (API 30+) - usa WindowInsetsControllerCompat
            WindowInsetsControllerCompat(window, window.decorView).let { controller ->
                controller.hide(WindowInsetsCompat.Type.statusBars() or WindowInsetsCompat.Type.navigationBars())
                controller.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
            }
        } else {
            // Android 10 e precedenti - usa API legacy
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = (
                View.SYSTEM_UI_FLAG_FULLSCREEN
                or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
            )
        }
    }
    
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            hideSystemUI()
        }
    }
    
    private fun setupWebView() {
        binding.webView.apply {
            settings.apply {
                javaScriptEnabled = true
                domStorageEnabled = true
                allowFileAccess = true
                allowContentAccess = true
                loadWithOverviewMode = true
                useWideViewPort = true
                // Disabilita completamente lo zoom
                builtInZoomControls = false
                displayZoomControls = false
                setSupportZoom(false)
                setBuiltInZoomControls(false)
            }
            
            // Aggiungi l'interface per ricevere dati dalla webapp
            addJavascriptInterface(WebAppInterface(), "Android")
            
            webViewClient = object : WebViewClient() {
                override fun onPageFinished(view: WebView?, url: String?) {
                    super.onPageFinished(view, url)
                    // Sito caricato silenziosamente
                }
            }
            
            // Carica il sito totem
            loadUrl("https://totem-web-app-nu.vercel.app")
        }
    }

    private fun setupUI() {
        binding.settingsButton.setOnClickListener {
            showSettingsDialog()
        }
    }
    
    private fun makePayment() {
        // Controlla se l'app è in modalità test
        if (!isActiveMode) {
            Log.d("App", "Modalità TEST: Ignorando richiesta di pagamento")
            // In modalità test, non fare nulla (senza popup)
            return
        }
        
        // Modalità ACTIVE: comportamento normale con pagamenti
        makePaymentOriginal()
    }
    
    private fun makePaymentOriginal() {
        // Verifica che la chiave affiliato sia configurata
        if (AFFILIATE_KEY == "YOUR_AFFILIATE_KEY") {
            Log.e("App", "Chiave affiliato non configurata")
            return
        }
        
        try {
            // Usa i dati ricevuti dalla webapp se disponibili, altrimenti usa valori di default
            val paymentData = currentPaymentData ?: PaymentData(
                totalPrice = 1.00,
                quantity = 1,
                museumId = "DEFAULT",
                timestamp = System.currentTimeMillis()
            )
            
            // Crea il pagamento SumUp con i dati ricevuti (comportamento originale)
            val payment = SumUpPayment.builder()
                // Parametri obbligatori
                .affiliateKey(AFFILIATE_KEY)
                .total(BigDecimal(paymentData.totalPrice.toString()))
                .currency(SumUpPayment.Currency.EUR)
                // Dettagli opzionali
                .title("Totem Payment - ${paymentData.quantity} biglietti")
                .receiptEmail("francesco.darin@amuseapp.it")
                .receiptSMS("+393401234567")
                // Metadati aggiuntivi
                .addAdditionalInfo("MuseumId", paymentData.museumId)
                .addAdditionalInfo("Quantity", paymentData.quantity.toString())
                .addAdditionalInfo("Timestamp", paymentData.timestamp.toString())
                .addAdditionalInfo("From", "Totem App")
                .addAdditionalInfo("To", "SumUp")
                // ID transazione esterna (deve essere unico)
                .foreignTransactionId(UUID.randomUUID().toString())
                // Salta la schermata di successo
                .skipSuccessScreen()
                .build()
            
            // Avvia il pagamento (SumUpAPI usa startActivityForResult internamente)
            SumUpAPI.checkout(this, payment, PAYMENT_REQUEST_CODE)
            
        } catch (e: Exception) {
            Log.e("App", "Errore durante la creazione del pagamento", e)
        }
    }
    
    
    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        if (requestCode == PAYMENT_REQUEST_CODE && data != null) {
            handlePaymentResult(resultCode, data)
        }
    }
    
    private fun handlePaymentResult(resultCode: Int, data: Intent) {
        when (resultCode) {
                    Activity.RESULT_OK -> {
                        // Pagamento completato con successo
                        val transactionCode = data.getStringExtra("tx_code")
                        val receiptNumber = data.getStringExtra("tx_receipt_number")
                        val transactionId = data.getStringExtra("tx_id")
                        
                        Log.d("App", "Pagamento completato con successo")
                        
                        // Log dei dettagli della transazione
                        println("Transazione completata:")
                        println("Codice transazione: $transactionCode")
                        println("Numero ricevuta: $receiptNumber")
                        println("ID transazione: $transactionId")
                        
                        // Redirect alla pagina di successo
                        binding.webView.loadUrl("https://totem-web-app-nu.vercel.app/thank-you")
                    }
            
                    Activity.RESULT_CANCELED -> {
                        // Pagamento annullato dall'utente
                        Log.d("App", "Pagamento annullato dall'utente")
                        
                        // Redirect alla pagina principale
                        binding.webView.loadUrl("https://totem-web-app-nu.vercel.app")
                    }
            
            else -> {
                // Errore o risultato sconosciuto
                val errorMessage = data.getStringExtra("error_message")
                Log.e("App", "Errore durante il pagamento: $errorMessage")
                
                // Redirect alla pagina principale in caso di errore
                binding.webView.loadUrl("https://totem-web-app-nu.vercel.app")
            }
        }
    }
    
    private fun showSettingsDialog() {
        val dialogView = LayoutInflater.from(this).inflate(R.layout.dialog_settings, null)
        val modeSwitch = dialogView.findViewById<SwitchCompat>(R.id.modeSwitch)
        val modeStatusText = dialogView.findViewById<TextView>(R.id.modeStatusText)
        
        // Imposta lo stato iniziale dello switch
        modeSwitch.isChecked = isActiveMode
        updateModeStatusText(modeStatusText, isActiveMode)
        
        // Aggiorna il testo quando lo switch cambia
        modeSwitch.setOnCheckedChangeListener { _, isChecked ->
            updateModeStatusText(modeStatusText, isChecked)
        }
        
        val dialog = AlertDialog.Builder(this)
            .setView(dialogView)
            .setTitle(getString(R.string.settings_title))
            .setPositiveButton(getString(R.string.save_settings)) { _, _ ->
                // Salva le impostazioni
                val newActiveMode = modeSwitch.isChecked
                sharedPreferences.edit()
                    .putBoolean("active_mode", newActiveMode)
                    .apply()
                
                isActiveMode = newActiveMode
                
                val modeText = if (isActiveMode) "Attivo" else "Test"
                Log.d("App", "Modalità cambiata: $modeText")
            }
            .setNegativeButton(getString(R.string.cancel_settings), null)
            .create()
        
        dialog.show()
    }
    
    private fun updateModeStatusText(textView: TextView, isActive: Boolean) {
        textView.text = if (isActive) {
            getString(R.string.mode_active)
        } else {
            getString(R.string.mode_test)
        }
    }
    
    // Classe per ricevere dati dalla webapp tramite JavaScript
    inner class WebAppInterface {
        @JavascriptInterface
        fun sendPaymentData(paymentDataJson: String) {
            try {
                // Parsing dei dati JSON ricevuti dalla webapp
                val paymentData = gson.fromJson(paymentDataJson, PaymentData::class.java)
                
                // Log per debug
                Log.d("WebApp", "Ricevuti dati pagamento: $paymentData")
                Log.d("WebApp", "Modalità attuale: ${if (isActiveMode) "Attivo" else "Test"}")
                
                // Salva i dati di pagamento
                currentPaymentData = paymentData
                
                // Avvia il pagamento
                runOnUiThread {
                    makePayment()
                }
                
            } catch (e: Exception) {
                Log.e("WebApp", "Errore nel parsing dati pagamento", e)
            }
        }
        
        /**
         * Metodo JavaScript interface per ottenere la modalità corrente dell'app
         * La web app può chiamare: Android.getAppMode()
         * @return JSON string con la modalità corrente (active o test)
         */
        @JavascriptInterface
        fun getAppMode(): String {
            return gson.toJson(mapOf(
                "mode" to (if (isActiveMode) "active" else "test"),
                "timestamp" to System.currentTimeMillis()
            ))
        }
    }
    
}
