# Keep annotations used by Razorpay and other libraries
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers
-keep @interface proguard.annotation.KeepPublicClassMembers

-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.PaymentsClient
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.Wallet
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.WalletUtils
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

# Keep Razorpay classes
-keep class com.razorpay.** { *; }

# Keep VibrationPlugin classes
-keep class com.benjaminabel.vibration.** { *; }
