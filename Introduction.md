# Software requirements #

In order for GNU Oflox to work properly, it requires
  * GNU Octave 3.2.3 or higher
  * GNU / Linux compatible Operating System
  * **[LaTeX](http://www.ctan.org/)** distribution (for the commands **latex** and **dvipdf**)
  * **dot** program from [graphviz](http://www.graphviz.org/)

# Networks #
The problems (networks) to be solved are specified in [DIMACS Challenge Min format](http://lpsolve.sourceforge.net/5.5/DIMACS.htm)
([DIMACS link](http://dimacs.rutgers.edu/Challenges/) and for file specs see [Section 7 of the Specs](ftp://dimacs.rutgers.edu/pub/netflow/general-info/specs.tex)), with a few extensions, [for more information on the extensions topic click here.](Dcmef.md)

# Installation #

Here we will discuss how to install and load this package. First you need to grab the most recent copy of this package, **gnuoflox-x.y.z-tar.gz**, and save it to the /tmp directory.

**Note:** the **x**, **y** and **z** in **gnuoflox-x.y.z-tar.gz** refer to the version numbers, for example, **gnuoflox-1.0.2-tar.gz**.

## Installing the package ##

To install the package open a console and follow these steps:
  1. `$ cd /tmp`
  1. `$ octave`
  1. **Update:** if using Ubuntu 10.04 or newer, then start GNU Octave with the `-f` switch, that is: `$ octave -f`
  1. `octave:1> pkg install gnuoflox-x.y.z-tar.gz`

The package is now installed, but to use it, you need to previously load it inside GNU Octave.

## Loading the package ##

To load the package execute GNU Octave and run the following command

`pkg load gnuoflox`

The package is then loaded and ready to be used. There are now two new commands available
  1. `oflox`, and
  1. `ofloxconfig`
these command will be explained shortly.

## Removing the package ##

To uninstall the package, execute GNU Octave and type the folloing command

`pkg uninstall gnuoflox`

After that, the package will be removed from your system.

## Upgrading to a newer version ##
In order to upgrade you first need to uninstall the previous version and then install the newer version, as described above.

# Using GNU Oflox #
Here we introduce the usage of the package through and example.

## Commands available and syntax ##
Once loaded the package in Octave, there are two commands available
  1. `oflox()`
  1. `ofloxconfig()`

### oflox ###
This is the main command of the GNU Oflox package, the correct syntax is

`[Z, X, it, it0] = oflox(filename, configuration);`

the `oflox` command requires **only** one parameter, `filename`, the variable specifying the path to `filename.min` that contains the problem (network) to be solved in [DIMACS Challenge MIN format](http://lpsolve.sourceforge.net/5.5/DIMACS.htm) ([DIMACS link](http://dimacs.rutgers.edu/Challenges/)). Extra configuration parameters can be customized via the configuration variable. This commands returns four variables

  * `Z` the cost of the optimal solution,
  * `X` the flows vector
  * `it` number of iterations required to find the optimal solution
  * `it0` number of iterations required to find a starting feasable solution in the case of using PHASE I.

### ofloxconfig ###
This is an auxiliary command used to configure the behaviour of the `oflox` command, it's syntax is very basic:

`configuration = ofloxconfig;`

The command returns the oflox-config structure:
```
configuration = 
{
  sol0 = 0
  FASE1 = 0
  BIGM =  1
  latex = 0
  aname = noname
  scale =  0.50000
  lang = en
  color_arc = #000000
  color_l = #8D0000
  color_u = #00C000
  color_art = #FF6A00
  color_thr = #AAAAFF
  color_pot = #DA03D7
  show_thread = 0
  show_depth = 0
  compiledvi = 0
  it_info = -1
}
```

Now will follow a brief description of each element of the structure:
| **Element** | **Description** |
|:------------|:----------------|
| **configuration.sol0**  |    Boolean value indicating wether to use or not the initial feaseble solution defined in ``filename''. Defaults to false.|
| **configuration.FASE1** |    Boolean value indicating wether the problem should be solved using PHASE 1 / PHASE 2. Defaults to false.|
| **configuration.BIGM**  |    Boolean value indicating wether the problem should be solved using Big M. Defaults to true.|
| **configuration.latex** |    Boolean value indicating wether to output latex code or not. Default to false.|
| **configuration.compiledvi** | Boolean value indicating wether to compile to DVI and PDF the \LaTeX generated source. This switch is only relevant is configuration.latex is true.|
| **configuration.aname** |    String specifying the latex output file pattern. Default to 'noname'.|
| **configuration.scale** |    float specifying the scale factor of the dot generated graphs used by `\includegraphics[scale=0.5]{...}`. This switch is only used if configuration.latex is true. Default to '0.5'.|
| **configuration.lang** |     Two coded caracters specifying the latex output language. Languages currently supported are:|
|  |      English ``en'' (default)|
|  |      Spanish ``es''|
| **configuration.color\_arc** | The color of the arcs in HTML coded color. Defaults to black (#000000).|
| **configuration.color\_l**  | The color of arcs in lower bound in HTML coded color. Defaults to red (#8D0000).|
| **configuration.color\_u** |  The color of arcs in upper bound in HTML coded color. Defaults to green (#00C000).|
| **configuration.color\_art** | The color of artificial arcs in HTML coded color. Defaults to orange (#FF6A00).|
| **configuration.color\_thr** | The color of the THREAD array (when displayed by configuration.show\_thread=true). Default to blue (#AAAAFF).|
| **configuration.color\_pot** | The color of the arcs that enters and leaves the tree on the same iteration. Defaults to magenta (#DA03D7).|
| **configuration.show\_thread** | Boolean value specifying wether to display the thread array on the tree graph. Defaults to false.|
| **configuration.show\_depth** | Boolean value specifying wether to display the depth array on the tree graph. Defaults to false.|
| **configuration.it\_info** |  This switch indicates that the information of a specific iteration is desired. The iteration information is displayed in DIMACS min extended format ready to be included in a DIMACS min extended file. Once displayed the information the iterations are stopped. If the value is less than 0 then no information is displayed. Defaults to -1.|

## Demo ##
For starters, let solve a simple network that is provided with the package. The network is described in [DIMACS Challenge MIN format](http://lpsolve.sourceforge.net/5.5/DIMACS.htm) ([DIMACS link](http://dimacs.rutgers.edu/Challenges/)) in the file

`~/octave/gnuoflox-x.y.z/doc/nets/pfmc300.min`

Start Octave and load the GNU Oflox package

```
pkg load gnuoflox
```

Now solve the network problem


```
[ Z X it it0 ] = oflox("~/octave/gnuoflox-x.y.z/doc/nets/pfmc300.min")
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

it =  6
it0 = 0
```

The output indicates
that the problem's objective optimum value is 4 units and can be achieved by setting each arc's flow as indicated by the vector X and required 6 Simplex FMC iterations and 0 PHASE I iterations (this is because the problem was solved using Big-M method).

It's this simple to use the basic features of GNU Oflox.
[Click here to view a more complete example](CompleteExample.md) that uses more advanced features.