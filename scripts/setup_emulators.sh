#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
# set -x
# VARIABLES
API_LEVEL=29

# Check Emulator already Installed
EMULATOR_COUNT=$(/Users/runner/Library/Android/sdk/tools/emulator -list-avds | wc -l)
if [[ ${EMULATOR_COUNT} -gt 0 ]]
then 
    echo "Emulator already available"
else
    # Install Emulator
    sudo /Users/runner/Library/Android/sdk/tools/bin/sdkmanager --update
    /Users/runner/Library/Android/sdk/tools/bin/sdkmanager --install "emulator"
    /Users/runner/Library/Android/sdk/tools/bin/sdkmanager --install "system-images;android-${API_LEVEL};google_apis;x86"
    echo "no" | /Users/runner/Library/Android/sdk/tools/bin/avdmanager --verbose create avd --force --name "pixel" --device "pixel" --package "system-images;android-${API_LEVEL};google_apis;x86" --tag "google_apis" --abi "x86"
    /Users/runner/Library/Android/sdk/emulator/emulator @pixel -no-window -no-boot-anim -netdelay none -no-snapshot -wipe-data -verbose -show-kernel -no-audio -gpu swiftshader_indirect -no-snapshot &> /tmp/log.txt &
    adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 5; done; input keyevent 82'
    adb shell settings put global window_animation_scale 0.0
    adb shell settings put global transition_animation_scale 0.0
    adb shell settings put global animator_duration_scale 0.0
    # Add ANDROID_SDK_ROOT
    echo sdk.dir=/Users/runner/Library/Android/sdk >> local.properties
fi


# LINUX:
# $ANDROID_HOME: /usr/local/lib/android/sdk
# MAC:
# $ANDROID_HOME: /Users/runner/Library/Android/sdk