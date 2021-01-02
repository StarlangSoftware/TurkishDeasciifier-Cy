from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["Deasciifier/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToolkit-Deasciifier-Cy',
    version='1.0.6',
    packages=['Deasciifier'],
    package_data={'Deasciifier': ['*.pxd', '*.pyx', '*.c']},
    url='https://github.com/StarlangSoftware/TurkishDeasciifier-Cy',
    license='',
    author='olcaytaner',
    author_email='olcay.yildiz@ozyegin.edu.tr',
    description='Turkish Asciifier/Deasciifier Library',
    install_requires=['NlpToolkit-MorphologicalAnalysis-Cy', 'NlpToolkit-NGram-Cy']
)
