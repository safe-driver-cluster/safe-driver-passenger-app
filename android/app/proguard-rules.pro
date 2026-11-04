# Keep rules for release builds when minification is re-enabled.
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.libraries.maps.** { *; }
-keep class com.google.maps.android.** { *; }
-keep class com.baseflow.geolocator.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
