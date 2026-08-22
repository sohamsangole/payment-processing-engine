#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================
# Payment Processing Engine - Android Setup
# ============================================================

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_DIR="$PROJECT_ROOT/android"

ANDROID_SDK="${ANDROID_HOME:-/usr/lib/android-sdk}"
JAVA_HOME_21="/usr/lib/jvm/java-21-openjdk-amd64"

PACKAGE_NAME="com.soham.paymentengine"
APP_NAME="PaymentProcessingEngine"

COMPILE_SDK=36
MIN_SDK=26
TARGET_SDK=36

GRADLE_VERSION="8.14"
AGP_VERSION="8.10.1"
KOTLIN_VERSION="2.2.0"

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------

log() {
    printf '\n\033[1;36m==> %s\033[0m\n' "$1"
}

fail() {
    printf '\n\033[1;31mERROR: %s\033[0m\n' "$1"
    exit 1
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# 1. Basic checks
# ------------------------------------------------------------

log "Checking environment"

if [[ "$(uname -s)" != "Linux" ]]; then
    fail "This script currently targets Linux/Ubuntu."
fi

if [[ ! -d "$ANDROID_DIR" ]]; then
    fail "android/ directory does not exist."
fi

if [[ ! -d "$JAVA_HOME_21" ]]; then
    fail "JDK 21 not found at $JAVA_HOME_21"
fi

export JAVA_HOME="$JAVA_HOME_21"
export PATH="$JAVA_HOME/bin:$PATH"

echo "JAVA_HOME=$JAVA_HOME"

java --version

# ------------------------------------------------------------
# 2. Android SDK
# ------------------------------------------------------------

log "Checking Android SDK"

if [[ ! -d "$ANDROID_SDK" ]]; then
    fail "Android SDK not found at $ANDROID_SDK"
fi

export ANDROID_HOME="$ANDROID_SDK"
export ANDROID_SDK_ROOT="$ANDROID_SDK"

SDKMANAGER="$ANDROID_SDK/cmdline-tools/16.0/bin/sdkmanager"

if [[ ! -x "$SDKMANAGER" ]]; then
    if command_exists sdkmanager; then
        SDKMANAGER="$(command -v sdkmanager)"
    else
        fail "sdkmanager not found."
    fi
fi

echo "Android SDK: $ANDROID_SDK"
echo "sdkmanager:  $SDKMANAGER"

# ------------------------------------------------------------
# 3. SDK packages
# ------------------------------------------------------------

log "Installing required Android SDK packages"

"$SDKMANAGER" "platform-tools"
"$SDKMANAGER" "platforms;android-${COMPILE_SDK}"
"$SDKMANAGER" "build-tools;36.0.0"

# ------------------------------------------------------------
# 4. Check SDK licenses
# ------------------------------------------------------------

log "Checking Android SDK licenses"

if [[ -t 0 ]]; then
    yes | "$SDKMANAGER" --licenses >/dev/null || true
else
    echo "Non-interactive shell detected; skipping license prompt."
fi

# ------------------------------------------------------------
# 5. Create Gradle wrapper if needed
# ------------------------------------------------------------

cd "$ANDROID_DIR"

if [[ ! -x "./gradlew" ]]; then
    log "Creating Gradle wrapper"

    if ! command_exists gradle; then
        fail "System Gradle is required to create the wrapper."
    fi

    gradle wrapper --gradle-version "$GRADLE_VERSION"
fi

chmod +x ./gradlew

# ------------------------------------------------------------
# 6. settings.gradle.kts
# ------------------------------------------------------------

log "Creating Gradle settings"

if [[ ! -f settings.gradle.kts ]]; then
cat > settings.gradle.kts <<'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "PaymentProcessingEngine"

include(":app")
EOF
fi

# ------------------------------------------------------------
# 7. gradle.properties
# ------------------------------------------------------------

if [[ ! -f gradle.properties ]]; then
cat > gradle.properties <<'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
EOF
fi

# ------------------------------------------------------------
# 8. Root build.gradle.kts
# ------------------------------------------------------------

if [[ ! -f build.gradle.kts ]]; then
cat > build.gradle.kts <<EOF
plugins {
    id("com.android.application") version "$AGP_VERSION" apply false
    id("org.jetbrains.kotlin.android") version "$KOTLIN_VERSION" apply false
    id("org.jetbrains.kotlin.plugin.compose") version "$KOTLIN_VERSION" apply false
}
EOF
fi

# ------------------------------------------------------------
# 9. App directory
# ------------------------------------------------------------

mkdir -p app/src/main/java/com/soham/paymentengine
mkdir -p app/src/main/res/values

# ------------------------------------------------------------
# 10. app/build.gradle.kts
# ------------------------------------------------------------

if [[ ! -f app/build.gradle.kts ]]; then
cat > app/build.gradle.kts <<EOF
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "$PACKAGE_NAME"

    compileSdk = $COMPILE_SDK

    defaultConfig {
        applicationId = "$PACKAGE_NAME"

        minSdk = $MIN_SDK
        targetSdk = $TARGET_SDK

        versionCode = 1
        versionName = "1.0"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.17.0")
    implementation("androidx.activity:activity-compose:1.10.1")

    implementation(platform("androidx.compose:compose-bom:2025.08.00"))

    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")

    debugImplementation("androidx.compose.ui:ui-tooling")
}
EOF
fi

# ------------------------------------------------------------
# 11. Android resources
# ------------------------------------------------------------

if [[ ! -f app/src/main/res/values/styles.xml ]]; then
cat > app/src/main/res/values/styles.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>

    <style
        name="Theme.PaymentProcessingEngine"
        parent="android:style/Theme.Material.Light.NoActionBar">
    </style>

</resources>
EOF
fi

# ------------------------------------------------------------
# 12. AndroidManifest.xml
# ------------------------------------------------------------

if [[ ! -f app/src/main/AndroidManifest.xml ]]; then
cat > app/src/main/AndroidManifest.xml <<'EOF'
<?xml version="1.0" encoding="utf-8"?>

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:label="Payment Processing Engine"
        android:theme="@style/Theme.PaymentProcessingEngine">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

        </activity>

    </application>

</manifest>
EOF
fi

# ------------------------------------------------------------
# 13. MainActivity.kt
# ------------------------------------------------------------

if [[ ! -f app/src/main/java/com/soham/paymentengine/MainActivity.kt ]]; then
cat > app/src/main/java/com/soham/paymentengine/MainActivity.kt <<'EOF'
package com.soham.paymentengine

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            MaterialTheme {
                Surface {
                    Text("Payment Processing Engine")
                }
            }
        }
    }
}
EOF
fi

# ------------------------------------------------------------
# 14. Verify Gradle
# ------------------------------------------------------------

log "Checking Gradle"

./gradlew --version

# ------------------------------------------------------------
# 15. Run Gradle tasks
# ------------------------------------------------------------

log "Validating Gradle project"

./gradlew tasks

# ------------------------------------------------------------
# 16. Build APK
# ------------------------------------------------------------

log "Building debug APK"

./gradlew :app:assembleDebug

APK="$ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk"

if [[ ! -f "$APK" ]]; then
    fail "APK was not generated."
fi

echo
echo "APK generated:"
echo "$APK"

# ------------------------------------------------------------
# 17. Detect Android device
# ------------------------------------------------------------

log "Checking Android devices"

if ! command_exists adb; then
    echo "adb is not installed."
    echo
    echo "Build completed successfully."
    exit 0
fi

adb start-server >/dev/null

DEVICE_COUNT="$(adb devices | awk 'NR > 1 && $2 == "device" { count++ } END { print count+0 }')"

if [[ "$DEVICE_COUNT" -eq 0 ]]; then
    echo
    echo "No Android device/emulator detected."
    echo
    echo "APK build succeeded:"
    echo "$APK"
    echo
    echo "Connect a phone or start an emulator, then run:"
    echo
    echo "adb install -r \"$APK\""
    exit 0
fi

# ------------------------------------------------------------
# 18. Install APK
# ------------------------------------------------------------

log "Installing APK"

adb install -r "$APK"

# ------------------------------------------------------------
# 19. Launch application
# ------------------------------------------------------------

log "Launching application"

adb shell am force-stop "$PACKAGE_NAME"

adb shell monkey \
    -p "$PACKAGE_NAME" \
    -c android.intent.category.LAUNCHER \
    1 >/dev/null

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------

echo
echo "=============================================="
echo " Android application is running"
echo "=============================================="
echo
echo "Package: $PACKAGE_NAME"
echo "APK:     $APK"
echo