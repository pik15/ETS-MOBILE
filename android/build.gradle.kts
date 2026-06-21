// File: android/build.gradle.kts (Root Project)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val sharedBuildDir = rootProject.layout.buildDirectory.dir("../../build").get().asFile
rootProject.layout.buildDirectory.set(sharedBuildDir)

subprojects {
    // 1. Mengatur direktori build bersama untuk setiap subproyek
    project.layout.buildDirectory.set(sharedBuildDir.resolve(project.name))
    
    // ==============================================================================
    // PERBAIKAN UTAMA KOTLIN DSL: Pemaksaan Resolusi Dependensi untuk Semua Subproyek
    // ==============================================================================
    project.configurations.configureEach {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.core" && requested.name == "core") {
                useVersion("1.13.1")
            }
            if (requested.group == "androidx.core" && requested.name == "core-ktx") {
                useVersion("1.13.1")
            }
        }
    }

    // 2. Menyuntikkan namespace secara paksa sebelum konfigurasi Gradle dikunci
    afterEvaluate {
        if (project.name == "isar_flutter_libs") {
            extensions.findByName("android")?.let { androidExt ->
                val baseExt = androidExt as? com.android.build.gradle.BaseExtension
                if (baseExt?.namespace == null) {
                    baseExt?.namespace = "dev.isar.isar_flutter_libs"
                }
            }
        }
        
        // Memaksa subproyek menggunakan compileSdk 36 agar sinkron dengan properti Android modern
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
                compileSdkVersion(36)
                defaultConfig {
                    targetSdkVersion(36)
                }
            }
        }
    }
}

// Evaluasi diatur secara spesifik pada root level
gradle.projectsEvaluated {
    tasks.findByName("examining") 
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}