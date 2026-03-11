#!/bin/bash
# Lissandra - Helper script para Docker
# Uso: ./lissandra.sh <escenario> <comando>
#
# Escenarios: base | kernel-test | lfs | memoria | stress
# Comandos:   up | down | logs | attach | clean
#
# Ejemplos:
#   ./lissandra.sh base up          # Levantar escenario base
#   ./lissandra.sh stress up        # Levantar escenario stress
#   ./lissandra.sh base attach      # Conectarse a la consola del Kernel
#   ./lissandra.sh base logs        # Ver logs de todos los containers
#   ./lissandra.sh base down        # Bajar el sistema
#   ./lissandra.sh base clean       # Bajar y borrar volumen LFS

set -e

SCENARIO=${1:-base}
CMD=${2:-up}

# Validar escenario
case "$SCENARIO" in
    base|kernel-test|lfs|memoria|stress) ;;
    *)
        echo "Escenario invalido: $SCENARIO"
        echo "Opciones: base | kernel-test | lfs | memoria | stress"
        exit 1
        ;;
esac

export SCENARIO

case "$CMD" in
    up)
        echo "Levantando Lissandra - escenario: $SCENARIO"
        docker compose --profile "$SCENARIO" up --build -d
        echo ""
        echo "Sistema levantado. Para conectarse al Kernel:"
        echo "  ./lissandra.sh $SCENARIO attach"
        ;;
    down)
        echo "Bajando Lissandra..."
        docker compose --profile "$SCENARIO" down
        ;;
    clean)
        echo "Bajando Lissandra y borrando datos del LFS..."
        docker compose --profile "$SCENARIO" down -v
        ;;
    logs)
        docker compose --profile "$SCENARIO" logs -f
        ;;
    attach)
        echo "Conectando a la consola LQL del Kernel..."
        echo "(Para desconectarse sin matar el proceso: Ctrl+P, Ctrl+Q)"
        echo ""
        docker attach lissandra-kernel-1
        ;;
    status)
        docker compose --profile "$SCENARIO" ps
        ;;
    *)
        echo "Comando invalido: $CMD"
        echo "Opciones: up | down | logs | attach | clean | status"
        exit 1
        ;;
esac
