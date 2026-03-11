#!/bin/sh
set -e

SCENARIO=${SCENARIO:-base}
LFS_DIR=/lfs

# Traduccion de nombre de escenario a directorio de deploy
case "$SCENARIO" in
    kernel-test) DEPLOY_SCENARIO=kernel ;;
    *)           DEPLOY_SCENARIO=$SCENARIO ;;
esac

CONFIG_DIR="/lissandra/docker/configs/$SCENARIO"

echo "=============================================="
echo "  Lissandra - Lo Compilaste Todo Chinguenguencha"
echo "  Escenario: $SCENARIO"
echo "=============================================="

# Inicializar sistema de archivos
mkdir -p "$LFS_DIR/Metadata"
if [ ! -f "$LFS_DIR/Metadata/Metadata.bin" ]; then
    echo "[allinone] Inicializando Metadata.bin..."
    cp "/lissandra/deploy/unasolavm/FileSystem/pruebas/$DEPLOY_SCENARIO/Metadata.bin" \
       "$LFS_DIR/Metadata/Metadata.bin"
fi

# Arrancar FileSystem en background
echo "[allinone] Iniciando FileSystem..."
/lissandra/FileSystem/Release/fileSystem "$CONFIG_DIR/filesystem/config_filesystem.cfg" &

sleep 1

# Arrancar nodos de memoria segun el escenario
echo "[allinone] Iniciando nodos de memoria para escenario $SCENARIO..."
case "$SCENARIO" in
    base)
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory1/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory2/config_memoria.cfg" &
        ;;
    kernel-test)
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory1/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory2/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory3/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory4/config_memoria.cfg" &
        ;;
    lfs)
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory1/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory2/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory3/config_memoria.cfg" &
        ;;
    memoria)
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory1/config_memoria.cfg" &
        ;;
    stress)
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory1/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory2/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory3/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory4/config_memoria.cfg" &
        /lissandra/PoolMemory/Release/poolmemory "$CONFIG_DIR/memory5/config_memoria.cfg" &
        ;;
esac

sleep 2

# El Kernel corre en foreground (consola interactiva)
echo "[allinone] Iniciando Kernel (consola LQL)..."
echo "  Scripts disponibles en /scripts/"
echo ""
exec /lissandra/Kernel/Release/kernel "$CONFIG_DIR/kernel/config_kernel.cfg"
