#!/usr/bin/env bash
# Usage: ./pack_dropin.sh <bzImage> <modules-root> <fw-root>
set -euo pipefail
BZ="${1:?bzImage path}"
MODROOT="${2:?modules root (contains lib/modules/<ver>)}"
FWROOT="${3:?firmware root (has ./nvidia and/or ./nouveau)}"

rm -rf dropin && mkdir -p dropin/android/system/lib/modules dropin/android/system/lib/firmware
cp -av "$BZ" dropin/kernel
rsync -a "$MODROOT"/ dropin/android/system/lib/modules/

# Android-x86 images ship firmware under /system/lib/firmware (kernel looks in /lib/firmware). cite
[ -d "$FWROOT/nvidia" ]  && rsync -a "$FWROOT/nvidia"/  dropin/android/system/lib/firmware/nvidia/
[ -d "$FWROOT/nouveau" ] && rsync -a "$FWROOT/nouveau"/ dropin/android/system/lib/firmware/nouveau/

echo "Drop-in ready at ./dropin/"
find dropin -maxdepth 3 -type f -print
