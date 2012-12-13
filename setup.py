from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

src_dir = "src"
sources = ["pyexip.pyx"]

sources_with_path = ["%s/%s" % (src_dir, source) for source in sources]


setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = cythonize([Extension("bin/pyexip", sources_with_path)])
)