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
mkdir -p ios/Counter.xcframework bindings ios/Counter

# Build the dylib
cargo build
 
# Generate bindings
cargo run --bin uniffi-bindgen generate --library ./target/debug/libcounter.dylib --language swift --out-dir ./bindings
 
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
mv ./bindings/counterFFI.modulemap ./bindings/module.modulemap
 
# Move the Swift file to the project
rm ./ios/Counter/Counter.swift || true
mv ./bindings/counter.swift ./ios/Counter/Counter.swift
 
# Recreate XCFramework
rm -rf "ios/Counter.xcframework" || true
        # -library ./target/aarch64-apple-ios/release/libcove.a -headers ./bindings \
xcodebuild -create-xcframework \
        -library ./target/aarch64-apple-ios-sim/debug/libcounter.a -headers ./bindings \
        -output "ios/Counter.xcframework"
 
# Cleanup
rm -rf bindings
