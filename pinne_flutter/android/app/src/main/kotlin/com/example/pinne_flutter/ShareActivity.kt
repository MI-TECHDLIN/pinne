package com.mitechdlin.pinne

import android.content.Intent
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Receives text and links shared from other apps and shows the compact
 * "Saved to Pinne" sheet over them. Runs the `shareMain` Dart entrypoint in
 * its own engine on a transparent window; finishing returns to the app that
 * shared.
 */
class ShareActivity : FlutterActivity() {
    override fun getDartEntrypointFunctionName(): String = "shareMain"

    override fun getBackgroundMode(): BackgroundMode = BackgroundMode.transparent

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "takeShare" -> result.success(readShare(intent))
                    "toast" -> {
                        val message = call.argument<String>("message").orEmpty()
                        Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT)
                            .show()
                        result.success(null)
                    }
                    "finish" -> {
                        result.success(null)
                        finish()
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun readShare(intent: Intent?): Map<String, String?>? {
        if (intent?.action != Intent.ACTION_SEND) return null
        val text = intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()
        val subject = intent.getStringExtra(Intent.EXTRA_SUBJECT)
            ?: intent.getStringExtra(Intent.EXTRA_TITLE)
        if (text.isNullOrBlank() && subject.isNullOrBlank()) return null
        return mapOf("text" to text, "subject" to subject)
    }

    private companion object {
        const val CHANNEL = "app.pinne/share"
    }
}
