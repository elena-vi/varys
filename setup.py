from distutils.core import setup

setup(
    name='varys',
    version='1.0.0',
    packages=['varys', 'varys.spiders'],
    url='https://github.com/elena-vi/varys',
    license='',
    author='Elena, Alex, Joe, Oliver',
    author_email='',
    description='A search engine',
    install_requires=[
        'Scrapy==1.8.2'
    ],
)
