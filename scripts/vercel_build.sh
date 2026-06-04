#!/usr/bin/env bash
set -euo pipefail

export FLUTTER_HOME="${HOME}/flutter"
export PATH="${FLUTTER_HOME}/bin:${PATH}"

if [ ! -d "${FLUTTER_HOME}" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "${FLUTTER_HOME}"
fi

flutter --version
flutter config --enable-web
flutter pub get
flutter build web --release
