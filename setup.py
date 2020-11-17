from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["Deasciifier/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToolkit-Deasciifier-Cy',
    version='1.0.4',
    packages=['Deasciifier'],
    package_data={'Deasciifier': ['*.pxd', '*.pyx', '*.c']},
    url='https://github.com/olcaytaner/TurkishDeasciifier-Cy',
    license='',
    author='olcay',
    author_email='olcaytaner@isikun.edu.tr',
    description='Turkish Asciifier/Deasciifier Library',
    install_requires=['NlpToolkit-MorphologicalAnalysis-Cy', 'NlpToolkit-NGram-Cy']
)
