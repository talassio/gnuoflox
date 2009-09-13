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
function ret = rm_artificials()
% NAME: Removes artificial arcs at the end of FASE 1 / BIGM
% SYNAPSIS: ret = rm_artificials()
% VERSION: 1.0
% DATE: 02/08/2008, 03/08/2008

global FLOX_PRED;
global THREAD;
global DEPTH;
global ARCCLASS;
global ARCOS;
global NODOS;
global TLU;
global DE;
global A;

global debug;
global ROOT;

%  if (debug), fprintf('init: Removing artificial arcs.\n'); end;

artificials = find(ARCCLASS==1);
TREES = zeros(NODOS, 1);

for ( i = length(artificials):-1:1 ),
%          if (debug), fprintf('Artificial arc %i/%i.\n', i, length(artificials)); end;
        k = DE(artificials(i));
        l = A(artificials(i));

        if ( FLOX_PRED(k) == l )
%                  if (debug), fprintf('Node %i is in T1 and %i is in T2\n', l, k); end;
                y = k;
        else
%                  if (debug), fprintf('Nodo %i is in T1 and %i is in T2\n', k, l); end;
                y = l;
        end

        TREES = ones(NODOS, 1);
        TREES(y) = 2;
        x = THREAD(y);
        while ( DEPTH(x) < DEPTH(y) )
                TREES(x) = 2;
                x = THREAD(x);
        end

        % here we know who is in T1 and T2
%          if (debug), fprintf('searching arc in L/U that unites T1 and T2.\n'); end;
        L = find(TLU~=0);
        for ( l = 1:length(L) ),
                if ( ( ( TREES(DE(L(l))) == 1 ) && ( TREES(A(L(l))) == 2 ) ) ||  ( ( TREES(DE(L(l))) == 2 ) && ( TREES(A(L(l))) == 1 ) ) ),
%                          if (debug), fprintf('T1: '); fprintf('%i ', find(TREES==1)); fprintf('\n'); end;
%                          if (debug), fprintf('T2: '); fprintf('%i ', find(TREES==2)); fprintf('\n'); end;
                        % Found arc!
                        % Put L(l) in T and take out artificials(i) from STAR and the rest.
%                          if (debug), fprintf('*** Metiendo el arco (%i, %i)[%i] en T.\n', DE(L(l)), A(L(l)), ARCCLASS(L(l))); end;
                        TLU(L(l)) = 0; % <---- !!!
                        % NEED TO FIX TPD !!!
                        % Note: if (l, k) == (DE(L(l)), A(L(l))), then TPD does not change
                        if ( ( ( k == DE(L(l)) ) && ( l == A(L(l)) ) ) || ( ( l == DE(L(l)) ) && ( k == A(L(l)) ) ) ),
                                % in & out arcs are equivalent, TPD does not change
                        else
                                actTPD(DE(L(l)), A(L(l)), DE(artificials(i)), A(artificials(i)));
                        end
%                          if (debug), fprintf('*** Removing arc (%i, %i)[%i] from STAR.\n', DE(artificials(i)), A(artificials(i)), ARCCLASS(artificials(i))); end;
                        rm_from_estrella(artificials(i));
                        l = -1;
                        break;
                end
        end
        if ( l ~= -1 ), error('BUG! Did not find any arc that unites T1 and T2, but this can not be!'); end;
end
