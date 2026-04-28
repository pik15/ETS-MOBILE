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
// Letakkan ini di baris paling bawah file android/app/build.gradle
subprojects {
    afterEvaluate {
        val project = this
        if (project.plugins.hasPlugin("com.android.library") || project.plugins.hasPlugin("com.android.application")) {
            val androidExtension = project.extensions.findByType(com.android.build.gradle.BaseExtension::class.java)
            androidExtension?.apply {
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
}