# Keep all classes in the com.dexterous package
-keep class com.dexterous.** { *; }

# Keep all classes in the com.dexterous.flutterlocalnotifications package
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Gson-related classes (if Gson is used by the plugin)
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer