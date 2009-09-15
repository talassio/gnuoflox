%  ############################################################################
%  #    This file is part of GNU Oflox                                        #
%  #    Copyright (C) 2006, 2007, 2008, 2009 by Andres Sajo                   #
%  #    talassio-at-gmail-dot-com                                             #
%  #                                                                          #
%  #    This program is free software; you can redistribute it and/or modify  #
%  #    it under the terms of the GNU General Public License as published by  #
%  #    the Free Software Foundation; either version 3 of the License, or     #
%  #    (at your option) any later version.                                   #
%  #                                                                          #
%  #    This program is distributed in the hope that it will be useful,       #
%  #    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
%  #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
%  #    GNU General Public License for more details.                          #
%  #                                                                          #
%  #    You should have received a copy of the GNU General Public License     #
%  #    along with this program; if not, write to the                         #
%  #    Free Software Foundation, Inc.,                                       #
%  #    59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
%  ############################################################################
%
%  Universidad Sim\'on Bol\'ivar
%  Coordinaci\'on de Matematicas
%  Departamento de C\'omputo Cient\'ifico y Estad\'istica
%
function ret = actTPD(k, l, p, q)
% NAME: Update of THREAD, DEPT & PRED
% REF:
% Taken verbatim from fortran code NETFLO.FOR
% ftp://dimacs.rutgers.edu/pub/netflow/netflow.tar
% Used lines: ~ 620 -- 790
%  C----------------------------------------------------------             JOY00040
%  C                                                                       JOY00050
%  C     NETFLO WAS WRITTEN BY R. V. HELGASON AND J. L. KENNINGTON         JOY00060
%  C                           OPERATIONS RESEARCH DEPT.                   JOY00070
%  C                           SOUTHERN METHODIST UNIVERSITY               JOY00080
%  C                           DALLAS, TEXAS 75275                         JOY00090
%  C                           (214)-692-3072                              JOY00100
%  C-----------------------------------------------------------            JOY00110
%  C                                                                       JOY00120
%  C     LAST REVISED -- FEB 1988                                          JOY00130
%  C                                                                       JOY00140
%  C-----------------------------------------------------------            JOY00150

global FLOX_PRED;
global THREAD;
global DEPTH;
global debug;

global ROOT;
if ( FLOX_PRED(q) == p ),
        f1 = p; f2 = q;
else
        f1 = q; f2 = p;
end;

%  if (debug), printf("* Nodes f1=%i, f2=%i.\n", f1, f2); end;

a = 0;
b = l;
while ( b ~= ROOT ),
%           if (debug), printf("%i == %i?\n", b, p); end;
        if ( b == p ),
                if ( FLOX_PRED(b) == q ),
                        a = 1;
                end;
                break;
        elseif ( b == q ),
                if ( FLOX_PRED(b) == p ),
                        a  = 1;
                end;
                break;
        end;
        b = FLOX_PRED(b);
end;

if ( a == ROOT ), % (p,q) belongs to the path from l to the ROOT
%          if (debug), printf("(%i->%i) DOES belong to the path from l=%i to the ROOT.\n", p, q, l); end;
        e1 = k; e2 = l;
else
%          if (debug), printf("(%i->%i) DOES NOT belong to the path from l=%i to the ROOT.\n", p, q, l); end;
        e1 = l; e2 = k;
end
%  if (debug), printf("* Nodes e1=%i, e2=%i.\n", e1, e2); end;

%  if (debug), printf("START update of TPD.\n"); end;

%% LEVEL = DEPTH;
%% DOWN = FLOX_PRED;
%% NEXT = THREAD;
%% q1 = e2;
%% q2 = e1;
%% itheta = f2;

i = e2;
j = FLOX_PRED(i);
lstar = DEPTH(e1) + 1;

        lsave = DEPTH(i);
        ldiff = lstar - lsave;
        DEPTH(i) = lstar;
        thd = i;
        nxt = THREAD(thd);
        while ( DEPTH(nxt) > lsave ),
                DEPTH(nxt) = DEPTH(nxt) + ldiff;
                thd = nxt;
                nxt = THREAD(thd);
        end;
        k = j;
        l = THREAD(k);
        while ~( l == i ),
                k = l;
                l = THREAD(k);
        end;
        while ~( i == f2 ), % 680: if ( i == f2 ), goto 790;
                THREAD(k) = nxt;
                THREAD(thd) = j;
                k = i;
                i = j;
                j = FLOX_PRED(j);
                FLOX_PRED(i) = k;
                lstar = lstar + 1;
% 680
                lsave = DEPTH(i);
                ldiff = lstar - lsave;
                DEPTH(i) = lstar;
                thd = i;
                nxt = THREAD(thd);
                while ~( DEPTH(nxt) <= lsave ),
                        DEPTH(nxt) = DEPTH(nxt) + ldiff;
                        thd = nxt;
                        nxt = THREAD(thd);
                end;
                k = j;
                l = THREAD(k);
                while ~( l == i),
                        k = l;
                        l = THREAD(k);
                end;
        end; %goto 680
% 790:
THREAD(k) = nxt;
THREAD(thd) = THREAD(e1);
THREAD(e1) = e2;
FLOX_PRED(e2) = e1;

%  if (debug), printf("END update of TPD.\n");end;

