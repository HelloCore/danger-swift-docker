FROM swift:5.1

MAINTAINER Orta Therox

# Install nodejs
RUN apt-get update -q \
    && apt-get install -qy curl \
    && mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-package \
    && curl -sL https://deb.nodesource.com/setup_10.x |  bash - \
    && apt-get install -qy nodejs \
    && rm -r /var/lib/apt/lists/*

# Install Swiftlint
ARG SWIFT_LINT_VER=0.39.1 
RUN git clone -b $SWIFT_LINT_VER --single-branch --depth 1 https://github.com/realm/SwiftLint.git _SwiftLint
RUN cd _SwiftLint && git submodule update --init --recursive; make install

# Install danger-js
ARG DANGER_JS_VER=9.2.10
RUN npm install -g danger@$DANGER_JS_VER

# Install danger-swift
ARG DANGER_SWIFT_VER=3.0.0
RUN git clone -b $DANGER_SWIFT_VER --single-branch --depth 1 https://github.com/danger/swift.git _DangerSwift
RUN cd _DangerSwift && git submodule update --init --recursive; make install

# Install swiftFormat
ARG SWIFT_FORMAT_VERSION=0.44.4
RUN curl -L https://github.com/nicklockwood/SwiftFormat/tarball/$SWIFT_FORMAT_VERSION | tar zx
    && mv */CommandLineTool/swiftformat /usr/local/bin

# ENTRYPOINT ["npx", "--package", "danger", "danger-swift", "ci"]
