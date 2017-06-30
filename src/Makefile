CC= gcc

CFLAGS=	-g -I$(IDIR)

ODIR = obj
LDIR = ../lib
IDIR = ../include

LIBS= -lm

_DEPS =	estruturas.h tradutor.h
_DEPS_montador = montador_ia32.h

DEPS =	$(patsubst %,$(IDIR)/%,$(_DEPS))
DEPS_montador = $(patsubst %,$(IDIR)/%,$(_DEPS_montador))

_OBJ = estruturas.o tradutor.o main_tradutor.o
_OBJ_montador = montador_ia32.o main_montador.o

OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))
OBJ_montador =  $(patsubst %,$(ODIR)/%,$(_OBJ_montador))

$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

tradutor: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

$(ODIR)/%.o: %.c $(DEPS_montador)
	$(CC) -c -o $@ $< $(CFLAGS)

montador: $(OBJ_montador)
		$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

.PHONY:
	clean

clean:
	rm -f $(ODIR)/*.o *~ core $(IDIR)/*~

traduzir:
	./tradutor $(asm_file)
