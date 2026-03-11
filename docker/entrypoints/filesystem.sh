#!/bin/sh
set -e

LFS_DIR=${LFS_DIR:-/lfs}
SCENARIO=${SCENARIO:-base}

# Map docker profile names to deploy directory names
case "$SCENARIO" in
    kernel-test) DEPLOY_SCENARIO=kernel ;;
    *)           DEPLOY_SCENARIO=$SCENARIO ;;
esac

mkdir -p "$LFS_DIR/Metadata"

if [ ! -f "$LFS_DIR/Metadata/Metadata.bin" ]; then
    echo "[filesystem] Inicializando Metadata.bin para escenario $SCENARIO..."
    cp "/lissandra/deploy/unasolavm/FileSystem/pruebas/$DEPLOY_SCENARIO/Metadata.bin" \
       "$LFS_DIR/Metadata/Metadata.bin"
fi

exec /lissandra/FileSystem/Release/fileSystem /config/config_filesystem.cfg
