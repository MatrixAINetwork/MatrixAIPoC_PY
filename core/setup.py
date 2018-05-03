#!/usr/bin/env python

from setuptools import setup, find_packages
from os.path import basename
from os.path import splitext
from glob import glob

setup(name='election',
      version='0.3.0',
      description='Matrix Masternodes Election',
      author='Cao Ao',
      author_email='caoao1994@163.com',
      url='',
      packages=find_packages('src'),
      package_dir={'': 'src'},
      py_modules=[splitext(basename(path))[0] for path in glob('src/*.py')],
      install_requires=['numpy','ecdsa']
     )
