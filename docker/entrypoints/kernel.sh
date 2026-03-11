#!/bin/bash
set -e

# Esperar que al menos memory1 este listo en su puerto
echo "[kernel] Esperando que memory1 este listo en memory1:8001..."
until bash -c "echo > /dev/tcp/memory1/8001" 2>/dev/null; do
    sleep 1
done
echo "[kernel] Nodo de memoria listo. Iniciando Kernel..."

exec /lissandra/Kernel/Release/kernel /config/config_kernel.cfg
