pyexip
======

An EXI (Efficient XML Interchange) solution for Python.

This is a wrapper on the C implementation EXIP (http://exip.sourceforge.net/) using Cython.

**Compilation:**  
Compile the extension module (pyexip.so) using the provided Makefile.

**Current Status:** (updated 12-21-2012)
+ Wrappers created for:
  - "serialize" API for schema-less encoding
  - BinaryBuffer
  - EXIStream
  - String
  - Qname
+ *src/test.py* contains a working "serialize" (encoding) example based on the example in Sec. 4.1 of the EXIP User Guide.
  
  
**Example usage:**  
The plan of the project is to provide two sets of API:
- The wrapped C API with the interface similar to that provided in C
- A Pythonic API that also provides conversion to and from XML (This has not been implemented yet)

```python
import pyexip

strm = pyexip.EXIStream()
serialize = pyexip.serialize()

serialize.initHeader(strm)
serialize.setHasCookie(strm)
buf = pyexip.BinaryBuffer(1024)
serialize.initStream(strm, buf)
...
```
