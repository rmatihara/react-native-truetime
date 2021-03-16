package com.pkgarg.truetime

import android.content.Context
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.instacart.library.truetime.TrueTime
import com.lyft.kronos.AndroidClockFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.IOException
import kotlin.coroutines.CoroutineContext

class RNTrueTimeModule(
    reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext), CoroutineScope {

    private val kronosClock by lazy {
        AndroidClockFactory.createKronosClock(reactContext)
    }



    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main

    override fun getName(): String {
        return "RNTrueTime"
    }

    @ReactMethod
    fun initTrueTime(promise: Promise) {
        val currentActivity: Context? = currentActivity
        try {
            initTrueTime(currentActivity)
        } catch (e: IOException) {
            e.printStackTrace()
            promise.reject("TRUETIME_INIT_ERR", e)
            return
        }
        promise.resolve("")
    }

    /**
     * Return ntp server time in millisecond that cannot be influenced by the user
     * @param promise
     */
    @ReactMethod
    fun getTrueTime(promise: Promise) {
        launch {
            try {
                promise.resolve(kronosClock.getCurrentNtpTimeMs().toString())
            } catch (e: Exception) {
                promise.resolve("0")
            }
        }
    }

    private suspend fun startTrueTime() = withContext(Dispatchers.IO) {
        try {
            initTrueTime(currentActivity)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    companion object {

        @Throws(IOException::class)
        fun initTrueTime(context: Context?) {
            TrueTimeSingleton.Instance().initialize(context)
        }
    }
}