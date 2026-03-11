# -*- MakeFile -*-

FLAGS    := -Wall -g
VENDOR   := vendor
INCLUDES := -I$(VENDOR)
LIBS     := -pthread -lreadline

# Commons source files to compile (vendored from so-commons-library)
COMMONS_SRCS := \
	$(VENDOR)/commons/log.c \
	$(VENDOR)/commons/config.c \
	$(VENDOR)/commons/string.c \
	$(VENDOR)/commons/bitarray.c \
	$(VENDOR)/commons/txt.c \
	$(VENDOR)/commons/temporal.c \
	$(VENDOR)/commons/process.c \
	$(VENDOR)/commons/error.c \
	$(VENDOR)/commons/memory.c \
	$(VENDOR)/commons/collections/list.c \
	$(VENDOR)/commons/collections/dictionary.c \
	$(VENDOR)/commons/collections/queue.c

all: default

default: clean dir commons comunicacion parser utils

.PHONY: dir
.SILENT: dir
dir:
	mkdir -p Release

.SILENT: commons
commons: $(COMMONS_SRCS)
	@for src in $(COMMONS_SRCS); do \
		name=$$(basename $$src .c); \
		gcc -c $$src $(FLAGS) $(INCLUDES) -o Release/commons_$$name.o && \
		echo "- Se compilo correctamente commons/$$name"; \
	done

.SILENT: comunicacion
comunicacion: src/$@.*
	gcc -c src/$@.c $(FLAGS) $(INCLUDES) $(LIBS) -o Release/$@.o
	echo "- Se compilo correctamente comunicacion"

.SILENT: parser
parser: src/$@.*
	gcc -c src/$@.c $(FLAGS) $(INCLUDES) $(LIBS) -o Release/$@.o
	echo "- Se compilo correctamente parser"

.SILENT: utils
utils: src/$@.*
	gcc -c src/$@.c $(FLAGS) $(INCLUDES) $(LIBS) -o Release/$@.o
	echo "- Se compilo correctamente utils"

.SILENT: clean
clean:
	rm -rf Release Debug */logger.log
	echo "Se hizo clean de las Utilguenguenchas"
