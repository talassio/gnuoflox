# Introduction #
This pages describes the extension to the [DIMACS Challenge Min](ftp://dimacs.rutgers.edu/pub/netflow/general-info/specs.tex) in order to
specify as input a feasible starting position.

# DIMACS MIN #
This format is well described at the [DIMACS Challenge Site](ftp://dimacs.rutgers.edu/pub/netflow/general-info/specs.tex) and in [lp\_solve](http://lpsolve.sourceforge.net/5.5/DIMACS.htm) documentation.

# Extension #

The main purpose of this extension in to allow the specification of one feasible point inside a MIN file. To fully specify a feasible starting point it is required to store the point's tree and those arcs that are on the upper bound, the rest of the required information is calculated based on these.

This extension **extends** the MIN format by introducing two (2) new commands characters
  1. **tree arcs** describe by
> > `t FROM TO`
  1. **upper bound arcs** described by
> > `u FROM TO`

**It is important to note that the current GNU Oflox implementation requires that this
extension in the MIN file occur after the description of the MIN problem**, an illustrative example follows
<pre>
c The FMC 100 problem<br>
c<br>
c TYPE NODES ARCS<br>
p min 6 10<br>
c FROM TO LOW CAP COST<br>
a 1    2  0   14  5<br>
a 3    1  0    5 -2<br>
a 3    2  0    3 -1<br>
a 3    4  0    5 -4<br>
a 3    6  0    4 -5<br>
a 4    2  0    7  5<br>
a 5    2  0    8  3<br>
a 5    4  0    5 -1<br>
a 6    4  0   15  7<br>
a 6    5  0    8  0<br>
c ID OFFER<br>
n 1    5<br>
n 2  -10<br>
n 3    9<br>
n 4  -11<br>
n 5   -3<br>
n 6   10<br>
c<br>
c Information for iteration 2, current cost z = 30, feasible but not optimal.<br>
c FROM TO FLOW (TREE arcs)<br>
t 1 2<br>
t 3 1<br>
t 5 2<br>
t 5 4<br>
t 6 4<br>
c FROM TO (UPPER arcs)<br>
u 3 4<br>
u 6 5<br>
c End<br>
</pre>

# Usage #
When solving a problem in which the MIN file has the above extension, GNU Oflox recognizes the extension but uses the feasible solution **only** if asked to start solving from that point, using setting `config.sol0 = true`; on the contrary it will default to use Big-M method from scratch, ignoring the file's feasible solution.

# Example #
```matlab

octave:2> co = ofloxconfig;
octave:3> co.sol0 = true; % Use feasible solution specified in file.
octave:4> [Z, flow, iter, iterF1] = oflox('filename.min', co)
```