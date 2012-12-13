OUTPUT_NAME=pyexip

all: ext

ext: $(OUTPUT_NAME).so

test:   ext
	python run_test.py

$(OUTPUT_NAME).so:  
	python setup.py build_ext --inplace

# Phony targets for cleanup and similar uses
.PHONY: clean
clean:
	python setup.py clean
	rm src/$(OUTPUT_NAME).c
	rm -rf bin
	rm -rf *~ *.so *.o build
