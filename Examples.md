# Screen shots #
The following screen shot sequence shows the tipical steps involved while solving a [Minimum Cost Flow network problem](http://en.wikipedia.org/wiki/Minimum_cost_flow), in this case, the [PFMCEXX1](http://gnuoflox.googlecode.com/files/pfmcexx1.min) problem.

Click an image to enlarge.

|(1/4) The problem in DIMACS Challenge Min Extended format, shown in the text editor Kate|(2/4) Octave while solving|
|:---------------------------------------------------------------------------------------|:-------------------------|
|![![](http://gnuoflox.googlecode.com/files/theminfile-small.png)](http://gnuoflox.googlecode.com/files/theminfile.png)|![![](http://gnuoflox.googlecode.com/files/theoctaveshell-small.png)](http://gnuoflox.googlecode.com/files/theoctaveshell.png)|
|(3/4) PDF Output double page 1/2|(4/4) Single output page showing the optimum solution for the problem PFMCEXX1 2/2|
|![![](http://gnuoflox.googlecode.com/files/theoutput1-small.png)](http://gnuoflox.googlecode.com/files/theoutput1.png)|![![](http://gnuoflox.googlecode.com/files/theoutput2-small.png)](http://gnuoflox.googlecode.com/files/theoutput2.png)|


# List of examples #
In this page you can find a list of problems (networks) and the steps followed by the Simplex FMC to solve them. The solutions are displayed in PDF format.

| **Problem Name** | **Description** | **Problem File** | **Solution** | **Uses Extended Format?** | **Shiped in Package?** |
|:-----------------|:----------------|:-----------------|:-------------|:--------------------------|:-----------------------|
| PFMCEXX1     | Very basic network of 4 nodes and 5 arcs. Problem solved with Big-M and displaying the Thread array in light red |  [![](http://gnuoflox.googlecode.com/files/text-48px.png)](http://gnuoflox.googlecode.com/files/pfmcexx1.min) | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_pfmcexx1.pdf) | no | yes|
| PFMC100      | Simple network of 6 nodes and 10 arcs. Solved with Phase I/II and displaying the Depth array| [![](http://gnuoflox.googlecode.com/files/text-48px.png)](http://gnuoflox.googlecode.com/files/pfmc100.min) | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_pfmc100.pdf) | yes | yes|
| PFMC200      | Another simple network of 6 nodes and 10 arcs. Solved with Big-M showing the Thread (in blue) and Depth arrays | [![](http://gnuoflox.googlecode.com/files/text-48px.png)](http://gnuoflox.googlecode.com/files/pfmc200.min) | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_pfmc200.pdf) | no | yes|
| PFMC201      | Same as above but solved from an initial feasable solution given in the same min file. | [![](http://gnuoflox.googlecode.com/files/text-48px.png)](http://gnuoflox.googlecode.com/files/pfmc201.min) | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_PFMC201.pdf) | yes | yes|
| PFMC300      | Simple network of 5 nodes and 8 arcs. Solved with Big-M | [![](http://gnuoflox.googlecode.com/files/text-48px.png)](http://gnuoflox.googlecode.com/files/pfmc300.min) | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_pfmc300.pdf) | no | yes|
|             | Same as above but solved with Phase I/II |  | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_fmc3.pdf) | no | yes|
| PFMC301      | A variation of problem PFM300 using infinite upperbound on some arcs. Solved with Phase I/II and showing the TREAD array | [![](http://gnuoflox.googlecode.com/files/text-48px.png)](http://gnuoflox.googlecode.com/files/pfmc301.min) | [![](http://gnuoflox.googlecode.com/files/pdf-48px.png)](http://gnuoflox.googlecode.com/files/master_pfmc301.pdf) | no | yes|