#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name = 'androguard',
    version = '1.9',
    packages = find_packages(),
    install_requires=['distribute'],
)
