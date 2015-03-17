# Running GNU Oflox Under Microsoft Windows #
![http://gnuoflox.googlecode.com/files/scr_win01.jpg](http://gnuoflox.googlecode.com/files/scr_win01.jpg)

This section covers the necesary steps to make GNU Oflox work under **Microsoft Windows XP** and **Vista**

## Software Requirements and Setup ##

The folloing software is required (tested version):

  * Microsoft Windows Vista (Version 6.0.6000). Note: GNU Oflox requires a _Windows Command Interpreter_ that can handle the

`for I in (set) do %nI`

directive correctly. For more information in this topic, try
`for /?` on the command prompt of CMD.EXE.
  * [GNU Octave windows version from OctaveForge](http://octave.sourceforge.net/) (Version 3.2.2)
  * [MikTeX distribution](http://miktex.org/) (Version 2.8), after instalation, make **sure** you download the folloing extra latex packages
    * xcolor
    * graphics
    * geometry
    * amsfonts
    * amsmath
  * [Graphviz program](http://www.graphviz.org/Download_windows.php) (Version 2.24.0)

Install all and make sure the `dot`, `latex` and `dvipdfm` programs can be accessible via the CMD.EXE console interpreter, that is,

`start->run...` then type `CMD.EXE [enter]`

on the command prompt, try

`dot -V`

Should appear

`dot - graphviz version 2.24.0 (20090616.2323)`

then, check the latex distribution

`latex -version`

which should say

`MiKTeX-pdfTeX 2.8.3512 (1.40.10) (MiKTeX 2.8)`

`Copyright (C) 1982 D. E. Knuth, (C) 1996-2006 Han The Thanh`

`TeX is a trademark of the American Mathematical Society.`

![http://gnuoflox.googlecode.com/files/menu-programs.png](http://gnuoflox.googlecode.com/files/menu-programs.png)

## Installing the GNU Oflox Package ##
Download from [here](http://code.google.com/p/gnuoflox/downloads/list) the latest gnuoflox-x.y.z-tar.gz package file and save it on your Desktop.

To install the GNU Oflox package, open GNU Octave and on the prompt type:

`octave-3.2.2.exe:1:C:\Octave\3.2.2\_gcc-4.3.0\bin

`> cd '~\Desktop'`

`octave-3.2.2.exe:2:~\Desktop`

`> pkg install gnuoflox-x.y.z-tar.gz'`

## Loading and Using it ##
Before using the `oflox()` function, you need to first load the package, on the GNU Octave console type:

`octave-3.2.2.exe:3:~\Desktop`

`> pkg load gnuoflox`

and now we are ready to use it! Lets give it a try

## Step by Step Example ##

`octave-3.2.2.exe:4:~\Desktop`

`> conf = ofloxconfig`

`octave-3.2.2.exe:5:~\Desktop`

`> conf.latex = 1; conf.compiledvi = 1;

We are now ready to solve a problem, the package includes a few simple problems, lets solve one of them

`octave-3.2.2.exe:6:~\Desktop`

`> [ Z X it it0 ] = oflox('C:\Octave\3.2.2_gcc-4.3.0\share\octave\packages\gnuoflox-1.0.4\doc\nets\pfmc100.min', conf);`

here follows a lot of output information...
```
octave-3.2.2.exe:13:~\Desktop
> [Z X it it0]=oflox('C:\Octave\3.2.2_gcc-4.3.0\share\octave\packages\gnuoflox-1.0.4\doc\nets\pfmc100.min', conf);
This is GNU Oflox. Copyright (C) 2009 Andres Sajo.
This is free software; see the source code for copying conditions.
There is ABSOLUTELY NO WARRANTY; not even for MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  For details, see `COPYING' file.
Running on a MS Windows machine.
information: The input file is DIMACS Challenge Min format with extensions
information: File contains initial solution information. Ignoring by sol0 = false.
warning: Degenerated iteration detected. The flows don't change.
warning: Using unsafe CMD.EXE calls
warning: NEED TO FIX WHICH COMMAND HERE
        1 file(s) copied.

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_0.dot" -o "M-noname_0.ps"   2>NUL  & del "M-noname_0.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_1.dot" -o "M-noname_1.ps"   2>NUL  & del "M-noname_1.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_1a.dot" -o "M-noname_1a.ps"   2>NUL  & del "M-noname_1a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_2.dot" -o "M-noname_2.ps"   2>NUL  & del "M-noname_2.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_2a.dot" -o "M-noname_2a.ps"   2>NUL  & del "M-noname_2a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_3.dot" -o "M-noname_3.ps"   2>NUL  & del "M-noname_3.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_3a.dot" -o "M-noname_3a.ps"   2>NUL  & del "M-noname_3a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_4.dot" -o "M-noname_4.ps"   2>NUL  & del "M-noname_4.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_4a.dot" -o "M-noname_4a.ps"   2>NUL  & del "M-noname_4a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_5.dot" -o "M-noname_5.ps"   2>NUL  & del "M-noname_5.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_5a.dot" -o "M-noname_5a.ps"   2>NUL  & del "M-noname_5a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_6.dot" -o "M-noname_6.ps"   2>NUL  & del "M-noname_6.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_6a.dot" -o "M-noname_6a.ps"   2>NUL  & del "M-noname_6a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_7.dot" -o "M-noname_7.ps"   2>NUL  & del "M-noname_7.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_7a.dot" -o "M-noname_7a.ps"   2>NUL  & del "M-noname_7a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_8.dot" -o "M-noname_8.ps"   2>NUL  & del "M-noname_8.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_8a.dot" -o "M-noname_8a.ps"   2>NUL  & del "M-noname_8a.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "M-noname_9.dot" -o "M-noname_9.ps"   2>NUL  & del "M-noname_9.dot"

C:\Users\Valued Customer\Desktop>dot -Tps "noname.dot" -o "noname.ps"   2>NUL  & del "noname.dot"
This is pdfTeX, Version 3.1415926-1.40.10 (MiKTeX 2.8)
entering extended mode
("C:\Users\Valued Customer\Desktop\master_noname.tex"
LaTeX2e <2005/12/01>
Babel <v3.8l> and hyphenation patterns for english, dumylang, nohyphenation, ge
rman, ngerman, german-x-2009-06-19, ngerman-x-2009-06-19, french, loaded.
("C:\Program Files\MiKTeX 2.8\tex\latex\base\article.cls"
Document Class: article 2005/09/16 v1.4f Standard LaTeX document class
("C:\Program Files\MiKTeX 2.8\tex\latex\base\size11.clo"))
("C:\Program Files\MiKTeX 2.8\tex\latex\graphics\graphics.sty"
("C:\Program Files\MiKTeX 2.8\tex\latex\graphics\trig.sty")
("C:\Program Files\MiKTeX 2.8\tex\latex\00miktex\graphics.cfg")
("C:\Program Files\MiKTeX 2.8\tex\latex\graphics\dvips.def"))
("C:\Program Files\MiKTeX 2.8\tex\latex\xcolor\xcolor.sty"
("C:\Program Files\MiKTeX 2.8\tex\latex\00miktex\color.cfg"))
("C:\Program Files\MiKTeX 2.8\tex\latex\amsfonts\amsfonts.sty")
("C:\Program Files\MiKTeX 2.8\tex\latex\ams\math\amsmath.sty"
For additional information on amsmath, use the `?' option.
("C:\Program Files\MiKTeX 2.8\tex\latex\ams\math\amstext.sty"
("C:\Program Files\MiKTeX 2.8\tex\latex\ams\math\amsgen.sty"))
("C:\Program Files\MiKTeX 2.8\tex\latex\ams\math\amsbsy.sty")
("C:\Program Files\MiKTeX 2.8\tex\latex\ams\math\amsopn.sty"))
("C:\Program Files\MiKTeX 2.8\tex\latex\geometry\geometry.sty"
("C:\Program Files\MiKTeX 2.8\tex\latex\graphics\keyval.sty")
("C:\Program Files\MiKTeX 2.8\tex\generic\oberdiek\ifpdf.sty")
("C:\Program Files\MiKTeX 2.8\tex\generic\oberdiek\ifvtex.sty")
("C:\Program Files\MiKTeX 2.8\tex\latex\geometry\geometry.cfg"))
("C:\Program Files\MiKTeX 2.8\tex\latex\amsfonts\umsa.fd")
("C:\Program Files\MiKTeX 2.8\tex\latex\amsfonts\umsb.fd")
("C:\Users\Valued Customer\Desktop\master_noname.aux")
*geometry auto-detecting driver*
*geometry detected driver: dvips*
<noname.ps> ("C:\Users\Valued Customer\Desktop\noname.tex") [1]
<M-noname_0.ps> ("C:\Users\Valued Customer\Desktop\M-noname_0.tex") [2]
("C:\Users\Valued Customer\Desktop\M-noname_TV_0.tex") <M-noname_1.ps>
<M-noname_1a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_1.tex") [3]
("C:\Users\Valued Customer\Desktop\M-noname_TV_1.tex") <M-noname_2.ps>
<M-noname_2a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_2.tex") [4]
("C:\Users\Valued Customer\Desktop\M-noname_TV_2.tex") <M-noname_3.ps>
<M-noname_3a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_3.tex") [5]
("C:\Users\Valued Customer\Desktop\M-noname_TV_3.tex") <M-noname_4.ps>
<M-noname_4a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_4.tex") [6]
("C:\Users\Valued Customer\Desktop\M-noname_TV_4.tex") <M-noname_5.ps>
<M-noname_5a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_5.tex") [7]
("C:\Users\Valued Customer\Desktop\M-noname_TV_5.tex") <M-noname_6.ps>
<M-noname_6a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_6.tex") [8]
("C:\Users\Valued Customer\Desktop\M-noname_TV_6.tex") <M-noname_7.ps>
<M-noname_7a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_7.tex") [9]
("C:\Users\Valued Customer\Desktop\M-noname_TV_7.tex") <M-noname_8.ps>
<M-noname_8a.ps> ("C:\Users\Valued Customer\Desktop\M-noname_8.tex") [10]
("C:\Users\Valued Customer\Desktop\M-noname_TV_8.tex") <M-noname_9.ps>
("C:\Users\Valued Customer\Desktop\M-noname_9.tex") [11]
("C:\Users\Valued Customer\Desktop\master_noname.aux") )
Output written on master_noname.dvi (11 pages, 53452 bytes).
Transcript written on master_noname.log.
master_noname.dvi -> master_noname.pdf
[1][2][3][4][5][6][7][8][9][10][11]
79783 bytes written

** WARNING ** -19 memory objects still allocated

MO: Master output document master_noname.tex compiled to master_noname.pdf
octave-3.2.2.exe:14:~\Desktop
>
```
now we have a bunch of file on the Desktop and the most important one is **master\_noname.pdf** go ahead and open it!
## Screen Shots ##
Here is a screen shot showing the GNU Octave window and a PDF output for the `pfmc100.min` problem.
![http://gnuoflox.googlecode.com/files/scr_win02.jpg](http://gnuoflox.googlecode.com/files/scr_win02.jpg)