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
    }
}

// PERBAIKAN: Evaluasi diatur secara spesifik pada root level, bukan di dalam semua subprojects
gradle.projectsEvaluated {
    tasks.findByName("examining") // Opsional, hanya memastikan siklus hidup aman
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}