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
function bigm()
% NAME: Creation of the Big-M arcs between the ROOT and the other nodes, a.k.a. FASE I...
% DATE: 20/08/2009

global A;
global DE;
global TLU;
global CPI;
global PI;
global U;
global X;
global FLOX_PRED;
global DEPTH;
global THREAD;
global TRAZA;
global C;
global U;
global AP;
global AR;
global B;
global NODOS;
global ARCOS;
global ROOT;
global debug;
global ARCCLASS; % Arc Class: natural, artificial
global BIGMCOST;

ROOT = 1; % DO NOT CHANGE, convention
TLU = -1 + (0 * TLU); % All arcs initialy belong to L, then as required we move them to T.
% initial TPD:
FLOX_PRED = [0; ones(NODOS-1, 1)];
DEPTH = FLOX_PRED;
THREAD = [[2:NODOS]' ; 1];

ARCCLASS = zeros(ARCOS, 1); % Zero for real, 1 for BIGM arcs

BIGMCOST = NODOS * max(abs(C)); % By definition

% Avoid listing node 1 that is the designated ROOT node:
nodos_oferta = find(B(2:NODOS)>=0) + 1;
nodos_demanda = find(B(2:NODOS)<0) + 1;

%  printf("Nodes SUPPLY: [%i]:\n", length(nodos_oferta))
for ( i = 1 : length(nodos_oferta) ),
        % See if arc (nodos_oferta(i),1) exists
        ced = cedula(nodos_oferta(i), ROOT, 0);
        if ( ced ~= -1 ) && (U(ced) >= B(nodos_oferta(i))),
%                  printf("natural arc (%i, %i) is in T (U=%i >= B=%i)\n", nodos_oferta(i), ROOT, U(ced), B(nodos_oferta(i)));
                TLU(ced) = 0; % put this arc in the TREE
        else
                % No natural arcs available, creating artificial one:
                % ARC (nodos_oferta(i) --> ROOT), cost=BIGMCOST, ubound=inf, update the arrays
%                  printf("arc does not exist or does not have enough capacity - creating ARTIFICIAL (%i, %i)\n", nodos_oferta(i), ROOT);
                add_to_estrella(nodos_oferta(i), ROOT, BIGMCOST, inf, 0, 1);
                ced = find(TLU==112); % Magic number to get the cedula of the just created estrella entry, there should be only one per add_to_estrella call.
                TLU(ced) = 0; % Artificial arco in the tree
        end
end

%  printf("Nodes DEMAND: [%i]:\n", length(nodos_demanda))
for ( i = 1 : length(nodos_demanda) ),
        % See if arc (nodos_demanda(i),1) exists
        ced = cedula(ROOT, nodos_demanda(i), 0);
        if ( ced ~= -1 ) && (U(ced) >= abs(B(nodos_demanda(i)))),
%                  printf("natural arc (%i, %i) is in T (U=%i >= ABS(B=%i_)\n", ROOT, nodos_demanda(i), U(ced), B(nodos_demanda(i)));
                TLU(ced) = 0; % Put arc in the TREE
        else
                % No natural arcs available, creating artificial one:
                % ARC (nodos_demanda(i) <-- ROOT), cost=BIGMCOST, ubound=inf, update the arrays
%                  printf("arc does not exist or does not have enough capacity - creating ARTIFICIAL (%i, %i)\n", ROOT, nodos_demanda(i));
                add_to_estrella(ROOT, nodos_demanda(i), BIGMCOST, inf, 0, 1);
                ced = find(TLU==112); % Magic number to get the cedula of the just created estrella entry, there should be only one per add_to_estrella call.
                TLU(ced) = 0; % Put new artificial arc in the TREE
        end
end

% Here we have the initial TREE

PI = zeros(NODOS, 1);
C(find(ARCCLASS==1)) = BIGMCOST;
return;

function ind = cedula(i, j, atype)
global A;
global AP;
global ARCCLASS;

global debug;

ind = 0;

%  if (debug ~= 0), printf('call to cedula(...) with search of arcs of type: %i.', atype); end;

for k = AP(i):AP(i+1)-1
        if ( (A(k) == j) && (ARCCLASS(k)==atype) ),
%                  if (debug)
%                          printf('Found at position %i [%i]!\n', k, ARCCLASS(k));
%                  end
                ind = k;
                return;
        end
end
        ind = -1;
end
