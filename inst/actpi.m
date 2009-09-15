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
function NPI = actpi(ced, sal)
% NAME: Potentials Update

global DE
global A
global FLOX_PRED;
global THREAD;
global PI;
global CPI;
global DEPTH;
global NODOS;
global debug;

global ROOT;

NPI = PI;

if (ced < 1 || sal < 1 ), error('ACTPI: input/output arcs missing.'); end;

p = DE(sal);
q = A(sal);

if ( FLOX_PRED(q) == p )
%          if (debug), fprintf('Node %i is in T1 and %i is in T2\n', p, q); end;
        y = q;
else
%          if (debug), fprintf('Node %i is in T1 and %i is in T2\n', q, p); end;
        y = p;
end

k = DE(ced);
l = A(ced);

%  if (debug), fprintf('\nUsing the arcs: (k, l) = (%i, %i), (p, q)=(%i, %i).\n\n', k, l, p, q); end


x = y;

while (1)
%          if (debug), fprintf('Node %i, (%i == %i) OR (%i == %i)\n', x, x, k, x, l); end
        if (x == k),
                % k in T2.
                change = CPI(ced);
%                  if (debug),
%                          fprintf('Node %i is in T2.\n', x);
%                          fprintf('x == k: the change constant is %i.\n', change);
%                  end
                break;

        elseif (x == l), % l in T2
                change = -CPI(ced);
%                  if (debug),
%                          fprintf('Nodo %i is in T2.\n', x);
%                          fprintf('x == l: the change constant is %i.\n', change);
%                  end
                break;

        end
        x = THREAD(x);
        if (x == ROOT),
                error('ACTPI: BUG! Reached the ROOT NODE!');
        end
end

% Time to update!

if (change == 0),
%          if (debug), fprintf("The potentials don\'t change...\n"); end;
else
%          if (debug), fprintf('Nodo %i, PI changes %i -> %i.\n', y, NPI(y), NPI(y) + change); end;
        NPI(y) = NPI(y) + change;

        x = THREAD(y);

        while ( DEPTH(x) > DEPTH(y) )
%                  if (debug), fprintf('Nodo %i, PI changes %i -> %i.\n', x, NPI(x), NPI(x) + change); end;
                NPI(x) = NPI(x) + change;
                x = THREAD(x);
        end
end

% Show the update:
%  fprintf('\n\nTable of potentials:\n');
%  fprintf('node\toldPI\tnewPI\n\n');
%  for i = 1:NODOS
%          fprintf('%i\t%i\t%i', i, PI(i), NPI(i));
%          fprintf('\n');
%  end
return;
