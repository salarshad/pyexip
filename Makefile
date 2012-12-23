OUTPUT_NAME=pyexip

all: ext dist

ext:
	python setup.py build_ext --inplace

test: ext
	python run_test.py
    
dist: ext
	python setup.py bdist --format=msi

# Phony targets for cleanup and similar uses
.PHONY: clean
clean:
	python setup.py clean
	rm src/$(OUTPUT_NAME).c
	rm -rf bin dist
	rm -rf *~ *.so *.o *.pyd build
	rm -rf exip-0.4.1/bin