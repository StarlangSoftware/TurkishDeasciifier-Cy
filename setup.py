from setuptools import setup

from pathlib import Path
this_directory = Path(__file__).parent
long_description = (this_directory / "README.md").read_text(encoding="utf-8")
from Cython.Build import cythonize

setup(
    ext_modules=cythonize(["Deasciifier/*.pyx"],
                          compiler_directives={'language_level': "3"}),
    name='NlpToolkit-Deasciifier-Cy',
    version='1.0.10',
    packages=['Deasciifier'],
    package_data={'Deasciifier': ['*.pxd', '*.pyx', '*.c'],
                  'Deasciifier.data': ['*.txt']},
    url='https://github.com/StarlangSoftware/TurkishDeasciifier-Cy',
    license='',
    author='olcaytaner',
    author_email='olcay.yildiz@ozyegin.edu.tr',
    description='Turkish Asciifier/Deasciifier Library',
    install_requires=['NlpToolkit-MorphologicalAnalysis-Cy', 'NlpToolkit-NGram-Cy'],
    long_description=long_description,
    long_description_content_type='text/markdown'
)
