
FILES=config.ml types.ml util.ml database.ml services.ml privileges.ml html_util.ml session.ml user_editor.ml nurpawiki.ml scheduler.ml history.ml about.ml

CAMLC = ocamlfind ocamlc -g $(LIB)
CAMLOPT = ocamlfind ocamlopt $(LIB)
CAMLDOC = ocamlfind ocamldoc $(LIB)
CAMLDEP = ocamlfind ocamldep
OCSIGENREP = `ocamlfind query ocsigen`
#OCSIGENREP = ../ocsigen/lib
 # ^ pour l'instant
LIB = -package netstring,str,calendar,extlib,postgresql,lwt -I $(OCSIGENREP)
PP = -pp "camlp4o $(OCSIGENREP)/xhtmlsyntax.cma"

OBJS = $(FILES:.ml=.cmo)

CMA = site.cma

all: $(CMA) install

$(CMA): $(OBJS)
	$(CAMLC) -a -o $(CMA) $(OBJS)

install:
	chmod a+r $(CMA)

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.PHONY: doc

NWIKI_VER=$(shell cat VERSION)
config.ml:config.ml.in VERSION
	echo $(NWIKI_VER)
	cat config.ml.in | \
	    sed -e "s|%_NURPAWIKI_VERSION_%|$(NWIKI_VER)|g" > config.ml

.ml.cmo:
	$(CAMLC) $(PP) -c $<

.mli.cmi:
	$(CAMLC) -c $<
.ml.cmx:
	$(CAMLOPT) $(PP) -c $<

doc:
#	$(CAMLDOC) -d doc -html db.mli

clean:
	-rm -f *.cm[ioxa] *~ $(NAME)

depend:
	$(CAMLDEP) $(PP) $(LIB) $(FILES:.ml=.mli) $(FILES) > .depend



