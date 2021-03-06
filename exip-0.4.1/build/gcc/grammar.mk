# StreamIO module build

GRAMMAR_OBJ = $(BIN_DIR)/eventsEXI.o $(BIN_DIR)/grammarRules.o $(BIN_DIR)/grammars.o \
			$(BIN_DIR)/emptyTypeGrammarGen.o $(BIN_DIR)/grammarAugment.o \
			$(BIN_DIR)/staticGrammarDefs.o
			
$(BIN_DIR)/eventsEXI.o : $(GRAMMAR_SRC)/include/eventsEXI.h $(GRAMMAR_SRC)/src/eventsEXI.c
		$(COMPILE) -c $(GRAMMAR_SRC)/src/eventsEXI.c -o $(BIN_DIR)/eventsEXI.o

$(BIN_DIR)/grammarRules.o : $(GRAMMAR_SRC)/include/eventsEXI.h $(GRAMMAR_SRC)/include/grammarRules.h $(GRAMMAR_SRC)/src/grammarRules.c
		$(COMPILE) -c $(GRAMMAR_SRC)/src/grammarRules.c -o $(BIN_DIR)/grammarRules.o
		
$(BIN_DIR)/grammars.o : $(GRAMMAR_SRC)/include/eventsEXI.h $(GRAMMAR_SRC)/include/grammarRules.h $(GRAMMAR_SRC)/src/grammars.c
		$(COMPILE) -c $(GRAMMAR_SRC)/src/grammars.c -o $(BIN_DIR)/grammars.o
		
$(BIN_DIR)/grammarAugment.o : $(GRAMMAR_SRC)/include/grammarAugment.h $(GRAMMAR_SRC)/src/grammarAugment.c
		$(COMPILE) -c $(GRAMMAR_SRC)/src/grammarAugment.c -o $(BIN_DIR)/grammarAugment.o

$(BIN_DIR)/emptyTypeGrammarGen.o : $(GRAMMAR_SRC)/src/emptyTypeGrammarGen.c
		$(COMPILE) -c $(GRAMMAR_SRC)/src/emptyTypeGrammarGen.c -o $(BIN_DIR)/emptyTypeGrammarGen.o

$(BIN_DIR)/staticGrammarDefs.o : $(GRAMMAR_SRC)/src/staticGrammarDefs.c
		$(COMPILE) -c $(GRAMMAR_SRC)/src/staticGrammarDefs.c -o $(BIN_DIR)/staticGrammarDefs.o