#!/usr/bin/python
"""
Implements the MDLP discretization criterion from Usama Fayyad's paper
"Multi-Interval Discretization of Continuous-Valued Attributes for
Classification Learning."
"""

from setuptools import Extension, find_packages, setup

if __name__ == '__main__':
    # see https://stackoverflow.com/a/42163080 for the approach to pushing
    # numpy and cython dependencies into extension building only
    try:
        # if Cython is available, we will rebuild from the pyx file directly
        from Cython.Distutils import build_ext
        sources = ['contained_keyword.pyx']
    except:
        # else we build from the cpp file included in the distribution
        from setuptools.command.build_ext import build_ext
        sources = ['contained_keyword.cpp']

    class CustomBuildExt(build_ext):
        """Custom build_ext class to defer numpy imports until needed.

        Overrides the run command for building an extension and adds in numpy
        include dirs to the extension build. Doing this at extension build time
        allows us to avoid requiring that numpy be pre-installed before
        executing this setup script.
        """

        def run(self):
            import numpy
            self.include_dirs.append(numpy.get_include())
            build_ext.run(self)

    cpp_ext = Extension(
        'contained_keyword',
        sources=sources,
        libraries=[],
        include_dirs=[],
        language='c++',
        extra_compile_args=['/openmp', '/Ox'],
        xtra_link_args=['/openmp']
    )

    setup(
        name='contained_keyword',
        version='0.1',
        description=__doc__,
        packages=find_packages(),
        ext_modules=[cpp_ext],
        cmdclass={'build_ext': CustomBuildExt},
    )