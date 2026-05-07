allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// PERBAIKAN FINAL: Atasi error lStar & Namespace Isar untuk Build Release
subprojects {
    afterEvaluate {
        val project = this
        if (project.plugins.hasPlugin("com.android.library") || project.plugins.hasPlugin("com.android.application")) {
            val androidExtension = project.extensions.findByType(com.android.build.gradle.BaseExtension::class.java)
            androidExtension?.apply {
                // 1. Paksa compileSdk ke 34 agar lStar ditemukan (Penting untuk Build Release)
                compileSdkVersion(34)
                
                // 2. Berikan namespace otomatis jika library belum memilikinya
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
}