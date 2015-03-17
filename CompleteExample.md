# A complete example #

In the following example we solve the [same problem used in the introduction page](Introduction#Usage.md), described by the file

`~/octave/gnuoctave-1.0.2/doc/nets/pfmc300.min`

but using Phase I/II and setting the output to a PDF file showing the initial problem, the steps involved and the optimum solution.

# Details #
It is strongly sugested to open a new folder for each problem to solve, so start off by opening the console, creating a new folder named `fmc3` and moving in to it
```
cd ~
mkdir fmc3
cd fmc3
```

Start up GNU Octave and load the package,
```
pkg load gnuoflox`
```
then type
```
config = ofloxconfig;
```

in order to customize the diverse settings. Let's
enable Phase I/II and disable Big-M methods
```
config.Phase1 = true;
config.BIGM = false;
```
enable the \LaTeX output
```
config.latex = true;
config.compiledvi = true;
```
and finally, set a name for the problem to solve

**Note: don't use special \LaTeX characters in the name! as underscores, &, or ^**

```
config.aname = 'fmc3';
```

Now we are ready to solve the problem!
```
[Z X it, it0] = oflox('~/octave/gnuoflox-1.0.1/doc/nets/pfmc300.min', config)
file is DIMACS MIN FORMAT
file is DIMACS MIN FORMAT read OK.
warning: Degenerated iteration detected. The flows don't change.
warning: Degenerated iteration detected. The flows don't change.
warning: Using the SYSTEM call.
`/home/andres/octave/gnuoflox-1.0.1/oflox_mo.tex' -> `master_fmc3.tex'
This is pdfTeXk, Version 3.141592-1.40.3 (Web2C 7.5.6)
...
Output written on master_fmc3.dvi (11 pages, 41464 bytes).
Transcript written on master_fmc3.log.
MO: Master output document master_fmc3.tex compiled to master_fmc3.dvi and master_fmc3.pdf
Z =  4
X =

   0
   3
   1
   1
   4
   3
   4
   3

it =  1
it0 =  5
```
indicating that the problem's objective optimum value is 4 units **as expected** (see the [Introductory page](Introduction#Usage.md)) and can be achieved by setting each arc's flow as indicated by the vector X, it required **only** 1 Simplex FMC iterations but **6** Phase I iterations. Besides this information we note the output states

`MO: Master output document master_fmc3.tex compiled to master_fmc3.dvi and master_fmc3.pdf`

indicating the output was written to [master\_fmc3.pdf](http://gnuoflox.googlecode.com/files/master_fmc3.pdf) and `master_fmc3.dvi`. if we look at the contents of the current working directory we note there are some 41 new files, namely



| F1-fmc3\_0.ps  |  F1-fmc3\_2.tex  | F1-fmc3\_5a.ps     | F1-fmc3\_TV\_2.tex  | fmc3\_1.ps      | fmc3\_TV\_1.tex   |
|:---------------|:-----------------|:-------------------|:--------------------|:----------------|:------------------|
| F1-fmc3\_0.tex |  F1-fmc3\_3a.ps  | F1-fmc3\_5.ps      | F1-fmc3\_TV\_3.tex  | fmc3\_1.tex     | master\_fmc3.aux |
| F1-fmc3\_1a.ps |  F1-fmc3\_3.ps   | F1-fmc3\_5.tex     | F1-fmc3\_TV\_4.tex  | fmc3\_2.ps      | **master\_fmc3.dvi** |
| F1-fmc3\_1.ps  |  F1-fmc3\_3.tex  | F1-fmc3\_6.ps      | F1-fmc3\_TV\_5.tex  | fmc3\_2.tex     | master\_fmc3.log |
| F1-fmc3\_1.tex |  F1-fmc3\_4a.ps  | F1-fmc3\_6.tex     | fmc3\_0.ps         | fmc3.ps        | **[master\_fmc3.pdf](http://gnuoflox.googlecode.com/files/master_fmc3.pdf)** |
| F1-fmc3\_2a.ps |  F1-fmc3\_4.ps   | F1-fmc3\_TV\_0.tex  | fmc3\_0.tex        | fmc3.tex       | master\_fmc3.tex |
| F1-fmc3\_2.ps  |  F1-fmc3\_4.tex  | F1-fmc3\_TV\_1.tex  | fmc3\_1a.ps        | fmc3\_TV\_0.tex  |                 |


but for now the **only** file we are interested is **[master\_fmc3.pdf](http://gnuoflox.googlecode.com/files/master_fmc3.pdf)**, go ahead and open it in your favourite PDF viewer and look at it's contents.

Most of the files listed in the above table are the LaTeX source files to generate master\_fmc3.pdf, they can be viewed and edited. The most important file is master\_fmc3.tex that is the one that includes all the other TeX source and PS graphic files, you are encouraged to view, edit and explore all the source files!

The folloing images show some pages of the PDF output (Click on them to enlarge)

| ![![](http://gnuoflox.googlecode.com/files/master_fmc3-0-small.png)](http://gnuoflox.googlecode.com/files/master_fmc3-0.png) | ![![](http://gnuoflox.googlecode.com/files/master_fmc3-2-small.png)](http://gnuoflox.googlecode.com/files/master_fmc3-2.png)| ![![](http://gnuoflox.googlecode.com/files/master_fmc3-9-small.png)](http://gnuoflox.googlecode.com/files/master_fmc3-9.png)| ![![](http://gnuoflox.googlecode.com/files/master_fmc3-10-small.png)](http://gnuoflox.googlecode.com/files/master_fmc3-10.png) |
|:-----------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|
|The problem | Iteration 1/6 of Phase I | Iteration 1/1 of Phase II | The solution |