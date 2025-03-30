{
  description = "rust-multiplatform development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    android-nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      # Configure Android SDK
      androidSdk = android-nixpkgs.sdk.${system} (sdkPkgs:
        with sdkPkgs; [
          # Essential build tools
          cmdline-tools-latest
          build-tools-35-0-0
          platform-tools

          # Platform & API level
          platforms-android-35

          # NDK for native code compilation
          ndk-28-0-13004108

          # Emulator for testing
          emulator
          system-images-android-35-google-apis-arm64-v8a
        ]);
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          androidSdk
          pkgs.jdk17
          pkgs.just
          pkgs.watchexec
        ];

        shellHook = ''
          # without this, adb can't run while mullvad is running for some reason ...
          export ADB_MDNS_OPENSCREEN=0

          export ANDROID_HOME=${androidSdk}/share/android-sdk
          export ANDROID_SDK_ROOT=${androidSdk}/share/android-sdk
          export ANDROID_NDK_ROOT=${androidSdk}/share/android-sdk/ndk/28.0.13004108
          # this will work with the `just create-emulator` command, but probably a better way to do this ...
          export ANDROID_AVD_HOME=$PWD/android-avd

          export JAVA_HOME=${pkgs.jdk17.home}
          export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

          just --list
        '';
      };
    });
}
