# Mantenha as classes do ExoPlayer
-keep class com.google.android.exoplayer2.** { *; }
-keep interface com.google.android.exoplayer2.** { *; }

# Mantenha as classes do ExoPlayer Dash
-keep class com.google.android.exoplayer2.source.dash.** { *; }
-keep interface com.google.android.exoplayer2.source.dash.** { *; }

# Se você estiver usando Anotações no ExoPlayer
-keepattributes *Annotation
