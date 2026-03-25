plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cardio_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // Mantendo o que configuramos antes
    }

    kotlinOptions {
        // CORREÇÃO: Nova sintaxe para evitar o aviso de depreciação
        jvmTarget = "17" 
    }

    defaultConfig {
        applicationId = "com.example.cardio_flutter"
        minSdk = flutter.minSdkVersion // Mantido para suporte ao desugaring/notificações
        
        // CORREÇÃO: O nome correto da propriedade é targetSdkVersion
        targetSdk = flutter.targetSdkVersion
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
