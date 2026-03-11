#!/bin/bash
set -e

# Esperar que el FileSystem este aceptando conexiones antes de arrancar
echo "[memory] Esperando que FileSystem este listo en filesystem:5003..."
until bash -c "echo > /dev/tcp/filesystem/5003" 2>/dev/null; do
    sleep 1
done
echo "[memory] FileSystem listo. Iniciando nodo de memoria..."

exec /lissandra/PoolMemory/Release/poolmemory /config/config_memoria.cfg
