/*
 * This file was generated by the Gradle 'init' task.
 *
 * This generated file contains a sample Java application project to get you started.
 * For more details on building Java & JVM projects, please refer to https://docs.gradle.org/8.6/userguide/building_java_projects.html in the Gradle documentation.
 */

import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar


plugins {
    // Apply the application plugin to add support for building a CLI application in Java.
    application

    id("com.gradleup.shadow") version "8.3.2"
}

repositories {
    // Use Maven Central for resolving dependencies.
    mavenCentral()

    // add local libraries
    flatDir {
        dirs("libs")
    }
}

dependencies {
    // Use JUnit test framework.
    testImplementation(libs.junit)

    // Used for palinedrome checking
    implementation(libs.commons.lang)

    // looks for the jar file in "palindrome_checker/libs"
    implementation(files("libs/jcommander-2.0.jar"))
}

// Apply a specific Java toolchain to ease working on different environmens.
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

application {
    // Define the main class for the application.
    mainClass = "palindrome_checker.Main"
}
