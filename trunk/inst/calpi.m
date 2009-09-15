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
function ret = calpi( )
% NAME: Potentials initial calculation
% SYNAPSIS: ret = calpi
% VERSION: 1.0
% DATE: 18/11/2006, 03/08/2008


global debug;
global NODOS;
global DE;
global A;
global C;

global TLU;
global FLOX_PRED;
global THREAD;
global PI;

global ROOT;

PI = zeros(NODOS,1); % !!! Overwriting potentials
j = THREAD(ROOT);
NTLU = TLU;
while (j ~= ROOT)
        i = FLOX_PRED(j);
%          if (debug)
%                  fprintf('searching (%i, %i) or (%i, %i) artificial o not in TREE\n', i, j, j, i);
%          end

        T = find( NTLU==0 );
        for t = 1:length(T),
                if ( i==DE(T(t)) && j==A(T(t)) ), break; end;
                if ( j==DE(T(t)) && i==A(T(t)) ), break; end;
        end
        ced = T(t);
        NTLU(ced) = -200;

        if (i == DE(ced)),
                if ( TLU(ced) == 0 ), PI(j) = PI(i) - C(ced); end;
        else
                PI(j) = PI(i) + C(ced);
        end
        j = THREAD(j);
end


%  if ( debug == true ),
%          fprintf('\n\nTable of potentials:\n');
%          fprintf('Nodes     :\t'); fprintf('%i\t', [1:NODOS]); fprintf('\n');
%          fprintf('Potentials:\t'); fprintf('%i\t', PI); fprintf('\n');
%  end
ret = PI;
