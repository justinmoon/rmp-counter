default:
    just --list

# Opens the android emulator (installs one on first run)
run-emulator:
    bash scripts/run-emulator.sh

# Cross-compile rust code for Android
build-android:
    bash scripts/build-android.sh

# Run the android app
run-android: build-android
    bash scripts/run-android.sh

# Opens iOS simulator
run-simulator:
    open -a Simulator

# Cross-compile rust code for iOS
build-ios profile="debug":
    bash scripts/build-ios.sh {% raw %}{{profile}}{% endraw %}

# Run the iOS app
run-ios: build-ios
    bash scripts/run-ios.sh

# Lint all source files
lint:
    cd rust
    cargo check
    cargo clippy
    cd ..

# Lint all source file lint errors
lint-fix:
    cd rust
    cargo fix --allow-dirty
    cargo clippy --fix --allow-dirty
    cd ..

# Hit the "home" button on android emulator (sometimes broken)
adb-home:
    adb shell input keyevent 3

# Delete all build artifacts and revert to basically fresh git checkout
clean:
    cd rust
    cargo clean
    cd ..
    rm -rf android/.gradle
