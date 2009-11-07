#!/bin/sh
echo -n 'Version number to use: (example 1.0.5) '
read VERSION
tar czvf gnuoflox-${VERSION}.tgz --exclude=.svn ./gnuoflox/inst ./gnuoflox/doc ./gnuoflox/DESCRIPTION ./gnuoflox/INDEX ./gnuoflox/COPYING
