#!/bin/bash
set -ex
cd rust

# FIXME: this is a hack to get xcode to find packages i installed via nix (like cargo)
export PATH=$PATH:/etc/profiles/per-user/justin/bin

BUILD_TYPE=$1

echo "Building for $BUILD_TYPE"
if [ "$BUILD_TYPE" == "release" ] || [ "$BUILD_TYPE" == "--release" ]; then
    BUILD_FLAG="--release"
elif [ "$BUILD_TYPE" == "debug" ] || [ "$BUILD_TYPE" == "--debug" ] ; then
    BUILD_FLAG=""
else
    BUILD_FLAG="--profile $BUILD_TYPE"
fi

# Make sure the directory exists
mkdir -p ios/{{ project-name | capitalize }}.xcframework bindings ios/{{ project-name | capitalize }}

# Build the dylib
cargo build
 
# Generate bindings
cargo run --bin uniffi-bindgen generate --library ./target/debug/lib{{ project-name | downcase }}.dylib --language swift --out-dir ./bindings
 
# Add the iOS targets and build
for TARGET in \
        aarch64-apple-ios-sim
        # aarch64-apple-darwin \
        # aarch64-apple-ios \
        # x86_64-apple-darwin \
        # x86_64-apple-ios
do
    rustup target add $TARGET
    cargo build --target=$TARGET $BUILD_FLAG
done
 
# Rename *.modulemap to module.modulemap
mv ./bindings/{{ project-name | downcase }}FFI.modulemap ./bindings/module.modulemap
 
# Move the Swift file to the project
rm ./ios/{{ project-name | capitalize }}/{{ project-name | capitalize }}.swift || true
mv ./bindings/{{ project-name | downcase }}.swift ./ios/{{ project-name | capitalize }}/{{ project-name | capitalize }}.swift
 
# Recreate XCFramework
rm -rf "ios/{{ project-name | capitalize }}.xcframework" || true
        # -library ./target/aarch64-apple-ios/release/libcove.a -headers ./bindings \
xcodebuild -create-xcframework \
        -library ./target/aarch64-apple-ios-sim/debug/lib{{ project-name | downcase }}.a -headers ./bindings \
        -output "ios/{{ project-name | capitalize }}.xcframework"
 
# Cleanup
rm -rf bindings
