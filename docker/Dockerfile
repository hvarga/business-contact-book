# Start from Ubuntu image.
FROM ubuntu:19.10

# Author information.
LABEL maintainer="hrvoje.varga@gmail.com"

# Install packages.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl apt-transport-https build-essential libxcb1-dev libicu-dev sudo \
        pkg-config locales sqlite3 mingw-w64 libglu1-mesa-dev libxkbcommon-x11-dev \
        libsqlite3-dev ninja-build wine64 libfontconfig1 mesa-common-dev gosu \
        mingw-w64-tools wget libxkbcommon-dev git gdb valgrind lcov pcmanfm vim \
        clang-tools python clang-tidy clang-format-6.0 xdg-utils xterm default-jre && \
    rm -rf /var/lib/apt/lists/*

# Configure system locale.
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8 \
    LC_MESSAGES=en_US.UTF-8 \
    LC_COLLATE=en_US.UTF-8

# Install Qt.
ENV QT_CI_PACKAGES=qt.qt5.5140.gcc_64,qt.qt5.5140.doc,qt.qt5.5140.src,qt.tools.qtcreator
RUN wget https://raw.githubusercontent.com/benlau/qtci/master/bin/extract-qt-installer \
        -O /usr/bin/extract-qt-installer && \
    chmod +x /usr/bin/extract-qt-installer && \
    wget --show-progress --progress=bar:force:noscroll \
        http://download.qt.io/official_releases/qt/5.14/5.14.0/qt-opensource-linux-x64-5.14.0.run \
        -O /tmp/qt.run && \
    chmod +x /tmp/qt.run && \
    /usr/bin/extract-qt-installer /tmp/qt.run /opt/qt && \
    rm -rf /tmp/qt.run

# Build Qt cross-compile SDK for Windows.
WORKDIR /opt/qt/5.14.0/Src
RUN ./configure \
        -xplatform win32-g++ \
        -device-option CROSS_COMPILE=/usr/bin/x86_64-w64-mingw32- \
        -prefix /opt/qt/5.14.0/mingw_64 \
        -opensource \
        -confirm-license \
        -no-compile-examples \
        -nomake examples \
        -nomake tests \
        -opengl desktop \
        -release \
        -optimize-size \
        -strip \
        -shared \
        -skip qtactiveqt -skip qtcharts -skip qtdoc -skip qtlocation \
        -skip qtremoteobjects -skip qtserialbus -skip qtwebchannel \
        -skip qtwebview -skip qtandroidextras -skip qtconnectivity \
        -skip qtgamepad -skip qtmacextras -skip qtpurchasing -skip qtscript \
        -skip qttranslations -skip qtwebengine -skip qtwinextras \
        -skip qtdatavis3d -skip qtgraphicaleffects -skip qtmultimedia \
        -skip qtquickcontrols -skip qtscxml -skip qtspeech \
        -skip qtvirtualkeyboard -skip qtwebglplugin -skip qtx11extras \
        -skip qt3d -skip qtcanvas3d -skip qtdeclarative \
        -skip qtimageformats -skip qtnetworkauth -skip qtquickcontrols2 \
        -skip qtlottie -skip qtquick3d -skip qtquicktimeline -skip qtserialport \
        -skip qtsvg -skip qttools -skip qtsensors -skip qtwayland \
        -skip qtwebsockets -skip qtxmlpatterns && \
    make -j$(nproc) && \
    make install

# Configure QtCreator SDK.
RUN /opt/qt/Tools/QtCreator/libexec/qtcreator/sdktool addQt \
        --id "x86-windows-msys-pe-64bit" \
        --name "Qt %{Qt:Version} (MinGW 64)" \
        --qmake /opt/qt/5.14.0/mingw_64/bin/qmake \
        --type Qt4ProjectManager.QtVersion.Desktop && \
    /opt/qt/Tools/QtCreator/libexec/qtcreator/sdktool addKit \
        --id "qt.qt5.5140.mingw_64_kit" \
        --name "Desktop Qt %{Qt:Version} MinGW 64" \
        --devicetype Desktop \
        --Ctoolchain "x86-windows-msys-pe-64bit" \
        --Cxxtoolchain "x86-windows-msys-pe-64bit" \
        --qt "x86-windows-msys-pe-64bit"

# Install DBeaver.
RUN wget --show-progress --progress=bar:force:noscroll \
        https://github.com/dbeaver/dbeaver/releases/download/6.3.2/dbeaver-ce_6.3.2_amd64.deb \
        -O /tmp/dbeaver.deb && \
    dpkg -i /tmp/dbeaver.deb && \
    rm -rf /tmp/dbeaver.deb

# When a user gains access to shell he will be put into a workspace directory.
WORKDIR /opt/workspace

# Install entrypoint script.
COPY entrypoint.sh /usr/local/bin

# Run entrypoint script.
ENTRYPOINT ["entrypoint.sh"]
