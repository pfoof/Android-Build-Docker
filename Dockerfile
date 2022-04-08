FROM gradle:7.4-jdk11-alpine

# Based on https://github.com/mingchen/docker-android-build-box

ENV ANDROID_HOME="/opt/android-sdk" \
    ANDROID_NDK="/opt/android-sdk/ndk/current" \
    TZ=Europe/Berlin \
    ANDROID_SDK_TOOLS_VERSION="8092744" \
    LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    PATH="$JAVA_HOME/bin:$PATH:$ANDROID_SDK_HOME/cmdline-tools/latest/bin:$ANDROID_SDK_HOME/emulator:$ANDROID_SDK_HOME/tools/bin:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_NDK" \
    ANDROID_SDK_HOME="$ANDROID_HOME" \
    ANDROID_NDK_HOME="$ANDROID_NDK"

WORKDIR /tmp

RUN apk add --no-cache wget git unzip && \
    wget --quiet --output-document=sdk-tools.zip \
      "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip" && \
    mkdir -p "$ANDROID_HOME/tmp" && \
    unzip -q sdk-tools.zip -d "$ANDROID_HOME/tmp" && \
    rm -f sdk-tools.zip && \
    mkdir -p "$ANDROID_HOME/cmdline-tools/latest/" && \
    mv "$ANDROID_HOME/tmp/cmdline-tools/bin" "$ANDROID_HOME/cmdline-tools/latest/bin" && \
    mv "$ANDROID_HOME/tmp/cmdline-tools/lib" "$ANDROID_HOME/cmdline-tools/latest/lib" && \
    mv "$ANDROID_HOME/tmp/cmdline-tools/source.properties" "$ANDROID_HOME/cmdline-tools/latest/source.properties" && \
    rm -r "$ANDROID_HOME/tmp"

ENV JAVA_OPTS="-XX:+IgnoreUnrecognizedVMOptions"

RUN yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --update && \
    yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "platforms;android-32" && \
    yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "platform-tools" && \
    yes | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager "build-tools;32.1.0-rc1"

RUN mkdir /project

WORKDIR /project
