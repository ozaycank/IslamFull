import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.isFile) {
    keystorePropertiesFile.inputStream().use {
        keystoreProperties.load(it)
    }
}

// Release tasks must never silently fall back to a debug signing key.
val releaseTaskRequested = gradle.startParameter.taskNames.any { taskName ->
    taskName.substringAfterLast(':').contains("release", ignoreCase = true)
}

if (releaseTaskRequested) {
    if (!keystorePropertiesFile.isFile) {
        throw GradleException(
            "Release signing is not configured. Create android/key.properties " +
                "with your private signing details before running a release task.",
        )
    }

    val requiredSigningProperties = listOf(
        "keyAlias",
        "keyPassword",
        "storeFile",
        "storePassword",
    )

    val missingSigningProperties = requiredSigningProperties.filter {
        keystoreProperties.getProperty(it).isNullOrBlank()
    }

    if (missingSigningProperties.isNotEmpty()) {
        throw GradleException(
            "Missing required entries in android/key.properties: " +
                missingSigningProperties.joinToString(", "),
        )
    }

    val configuredStoreFile = file(
        keystoreProperties.getProperty("storeFile").orEmpty(),
    )

    if (!configuredStoreFile.isFile) {
        throw GradleException(
            "The release keystore file does not exist at the configured storeFile path.",
        )
    }
}

android {
    namespace = "com.ozaycank.islamfull"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications for scheduled notifications
        // on Android versions that do not provide all modern Java APIs.
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Keep this identifier stable after the first store publication.
        applicationId = "com.ozaycank.islamfull"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let {
                file(it)
            }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.0.3",
    )
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}