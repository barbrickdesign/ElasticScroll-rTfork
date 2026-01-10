"""Setup configuration for elasticscroll package."""

from setuptools import setup, find_packages
from pathlib import Path

# Read the contents of README file
this_directory = Path(__file__).parent
long_description = (this_directory / "README.md").read_text(encoding='utf-8')

setup(
    name='elasticscroll',
    version='0.1.0',
    description='Minimal library for efficient elasticsearch queries',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/departmentofdefense/ElasticScroll',
    author='Isaac Sears',
    author_email='isears@friends.dds.mil',
    license='MIT',
    classifiers=[
        # Development status
        'Development Status :: 4 - Beta',
        
        # Intended audience
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Libraries :: Python Modules',
        
        # License
        'License :: OSI Approved :: MIT License',
        
        # Python version support
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
        
        # Operating systems
        'Operating System :: OS Independent',
    ],
    keywords='elasticsearch, scroll, query, search, database',
    packages=find_packages(exclude=['tests', 'tests.*']),
    python_requires='>=3.7',
    install_requires=[
        'elasticsearch>=7.0.0,<9.0.0',
    ],
    extras_require={
        'dev': [
            'pytest>=7.0.0',
            'pytest-cov>=4.0.0',
            'black>=22.0.0',
            'flake8>=5.0.0',
            'mypy>=0.990',
            'isort>=5.10.0',
        ],
        'test': [
            'pytest>=7.0.0',
            'pytest-cov>=4.0.0',
        ],
    },
    zip_safe=False,
    project_urls={
        'Bug Reports': 'https://github.com/departmentofdefense/ElasticScroll/issues',
        'Source': 'https://github.com/departmentofdefense/ElasticScroll',
    },
)
