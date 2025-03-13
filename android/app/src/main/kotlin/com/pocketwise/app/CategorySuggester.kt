package com.pocketwise.app

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import java.util.concurrent.TimeUnit
import android.content.SharedPreferences

class CategorySuggester(private val context: Context) {
    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS)
        .readTimeout(30, TimeUnit.SECONDS)
        .writeTimeout(30, TimeUnit.SECONDS)
        .build()

    private val apiKey = "AIzaSyBypz-tpEVCdtlHTjKuLmxT1kRRZY2k6Fw"
    private val baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    private val prefs: SharedPreferences = context.getSharedPreferences("category_cache", Context.MODE_PRIVATE)
    
    // Cache duration in milliseconds (30 minutes)
    private val CACHE_DURATION = TimeUnit.MINUTES.toMillis(30)

    // Common merchant categories for faster response
    private val commonMerchants = mapOf(
        "TOTAL" to listOf("Fuel", "Transport", "Car Expenses"),
        "SHELL" to listOf("Fuel", "Transport", "Car Expenses"),
        "NAIVAS" to listOf("Groceries", "Shopping", "Household"),
        "CARREFOUR" to listOf("Groceries", "Shopping", "Household"),
        "UBER" to listOf("Transport", "Travel", "Services"),
        "BOLT" to listOf("Transport", "Travel", "Services"),
        "NETFLIX" to listOf("Entertainment", "Subscriptions", "Digital Services"),
        "SPOTIFY" to listOf("Entertainment", "Subscriptions", "Digital Services"),
        "JUMIA" to listOf("Shopping", "Online Shopping", "General"),
        "KFC" to listOf("Food", "Dining", "Fast Food")
    )

    suspend fun processTransactionMessage(message: String): Triple<String, String, List<String>> = withContext(Dispatchers.IO) {
        try {
            Log.d("CategorySuggester", "=== Starting processTransactionMessage ===")
            Log.d("CategorySuggester", "Processing message: $message")

            val prompt = """
                Analyze this M-PESA transaction message and extract:
                1. The exact amount (in Ksh)
                2. The merchant name
                3. Three most appropriate expense categories from this list:
                   - Food & Dining
                   - Transportation
                   - Shopping
                   - Utilities
                   - Entertainment
                   - Healthcare
                   - Education
                   - Housing
                   - Personal Care
                   - Travel
                   - Gifts & Donations
                   - Insurance
                   - Investments
                   - Other

                Message: "$message"

                Format your response as a JSON object with these exact keys:
                {
                    "amount": "exact amount with 2 decimal places",
                    "merchant": "exact merchant name",
                    "categories": ["category1", "category2", "category3"]
                }
            """.trimIndent()

            Log.d("CategorySuggester", "=== AI Request Details ===")
            Log.d("CategorySuggester", "Prompt: $prompt")

            val requestBody = JSONObject().apply {
                put("contents", JSONObject().apply {
                    put("parts", JSONObject().apply {
                        put("text", prompt)
                    })
                })
            }

            Log.d("CategorySuggester", "Request Body: ${requestBody.toString(2)}")

            val request = Request.Builder()
                .url("$baseUrl?key=$apiKey")
                .post(requestBody.toString().toRequestBody("application/json".toMediaType()))
                .build()

            Log.d("CategorySuggester", "Sending request to: $baseUrl")
            val response = client.newCall(request).execute()
            
            if (!response.isSuccessful) {
                Log.e("CategorySuggester", "=== API Call Failed ===")
                Log.e("CategorySuggester", "Response code: ${response.code}")
                Log.e("CategorySuggester", "Response body: ${response.body?.string()}")
                return@withContext Triple("0.00", "Unknown Merchant", getDefaultCategories())
            }

            val responseBody = response.body?.string()
            if (responseBody == null) {
                Log.e("CategorySuggester", "Empty response body")
                return@withContext Triple("0.00", "Unknown Merchant", getDefaultCategories())
            }

            Log.d("CategorySuggester", "=== AI Response Details ===")
            Log.d("CategorySuggester", "Raw Response: $responseBody")

            val jsonResponse = JSONObject(responseBody)
            val candidates = jsonResponse.getJSONArray("candidates")
            if (candidates.length() == 0) {
                Log.e("CategorySuggester", "No candidates in response")
                return@withContext Triple("0.00", "Unknown Merchant", getDefaultCategories())
            }

            val content = candidates.getJSONObject(0).getJSONObject("content")
            val parts = content.getJSONArray("parts")
            if (parts.length() == 0) {
                Log.e("CategorySuggester", "No parts in content")
                return@withContext Triple("0.00", "Unknown Merchant", getDefaultCategories())
            }

            val text = parts.getJSONObject(0).getString("text")
            Log.d("CategorySuggester", "Raw text from response: $text")

            // Clean up the response by removing markdown formatting and extra whitespace
            val cleanText = text
                .replace(Regex("```json\\s*"), "") // Remove ```json prefix
                .replace(Regex("```\\s*"), "")     // Remove ``` suffix
                .trim()
            
            Log.d("CategorySuggester", "Cleaned text: $cleanText")
            
            val result = JSONObject(cleanText)
            val amount = result.getString("amount")
            val merchant = result.getString("merchant")
            val categories = result.getJSONArray("categories").let { array ->
                List(array.length()) { array.getString(it) }
            }
            
            Log.d("CategorySuggester", "=== Processing Results ===")
            Log.d("CategorySuggester", "Amount: $amount")
            Log.d("CategorySuggester", "Merchant: $merchant")
            Log.d("CategorySuggester", "Categories: $categories")
            
            // Cache the results
            cacheCategories(merchant, categories)
            
            Triple(amount, merchant, categories)

        } catch (e: Exception) {
            Log.e("CategorySuggester", "=== Error in processTransactionMessage ===")
            Log.e("CategorySuggester", "Error details: ${e.message}")
            Log.e("CategorySuggester", "Stack trace: ${e.stackTraceToString()}")
            Triple("0.00", "Unknown Merchant", getDefaultCategories())
        }
    }

    private fun getDefaultCategories(): List<String> {
        return listOf("Shopping", "Food & Dining", "Other")
    }

    private fun getCachedCategories(merchantName: String): List<String>? {
        val cacheKey = "merchant_${merchantName.lowercase()}"
        val cachedData = prefs.getString(cacheKey, null) ?: return null
        val timestamp = prefs.getLong("${cacheKey}_timestamp", 0)
        
        // Check if cache is still valid
        if (System.currentTimeMillis() - timestamp > CACHE_DURATION) {
            Log.d("CategorySuggester", "Cache expired for merchant: $merchantName")
            return null
        }

        Log.d("CategorySuggester", "Found cached categories for merchant: $merchantName")
        return try {
            cachedData.split(",")
        } catch (e: Exception) {
            Log.e("CategorySuggester", "Error parsing cached categories: ${e.message}")
            null
        }
    }

    private fun cacheCategories(merchantName: String, categories: List<String>) {
        val cacheKey = "merchant_${merchantName.lowercase()}"
        Log.d("CategorySuggester", "Caching categories for merchant: $merchantName")
        Log.d("CategorySuggester", "Categories to cache: $categories")
        prefs.edit().apply {
            putString(cacheKey, categories.joinToString(","))
            putLong("${cacheKey}_timestamp", System.currentTimeMillis())
            apply()
        }
    }
} 