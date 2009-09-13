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
function ret = add_to_estrella(de, a, c, u, x, aclass)
% NAME: Adds an entry to STAR and updates the related structures
% SYNOPSIS: ret = add_to_estrella(de, a, c, u, x, aclass)
% VERSION: 1.0
% DATE: 02/08/2008, 03/08/2008

global DE
global A
global AP
global AR
global C
global ARCCLASS
global ARCOS
global TRAZA
global U
global X
global debug
global NODOS
global TLU

newDE = [DE; 0];
newA = [A; 0];
newC = [C; 0];
newARCCLASS = [ARCCLASS; 2];
newX = [X; 0];
newU = [U; 0];
newTLU = [TLU; 100];

newPosition = AP(de+1);

% Space for the new element
newDE(newPosition+1:ARCOS+1) = DE(newPosition:ARCOS);
newA(newPosition+1:ARCOS+1)  = A(newPosition:ARCOS);
newC(newPosition+1:ARCOS+1) = C(newPosition:ARCOS);
newX(newPosition+1:ARCOS+1)  = X(newPosition:ARCOS);
newU(newPosition+1:ARCOS+1)  = U(newPosition:ARCOS);
newARCCLASS(newPosition+1:ARCOS+1)  = ARCCLASS(newPosition:ARCOS);
newTLU(newPosition+1:ARCOS+1) = TLU(newPosition:ARCOS);

% new element
newDE(newPosition) = de;
newA(newPosition)  = a;
newX(newPosition)  = x;
newU(newPosition)  = u;
newARCCLASS(newPosition) = aclass;
newC(newPosition) = 1;
newTLU(newPosition) = 112;

% Update
AP(de+1:NODOS+1) = AP(de+1:NODOS+1) + 1;
DE = newDE;
A  = newA;
C  = newC;
ARCCLASS = newARCCLASS;
X  = newX;
U  = newU;
TLU = newTLU;

% Fix up the lexicographic order of the arrays
[A([AP(de):AP(de+1)-1]), index] = sort(A([AP(de):AP(de+1)-1]));
t=C([AP(de):AP(de+1)-1]);
C([AP(de):AP(de+1)-1])=t(index);
t=U([AP(de):AP(de+1)-1]);
U([AP(de):AP(de+1)-1])=t(index);
t=ARCCLASS([AP(de):AP(de+1)-1]);
ARCCLASS([AP(de):AP(de+1)-1])=t(index);
t=X([AP(de):AP(de+1)-1]);
X([AP(de):AP(de+1)-1])=t(index);
t=TLU([AP(de):AP(de+1)-1]);
TLU([AP(de):AP(de+1)-1])=t(index);


TRAZA = [];
AR(1) = 1;
for (i = 1:NODOS-1)
        TRAZA = cat(1, TRAZA, find(A==(i)));
        AR(i+1) = AR(i) + sum( A==i );
end
TRAZA = cat(1, TRAZA, find(A==(NODOS)));
AR(NODOS+1) = ARCOS+2;

ARCOS = ARCOS + 1;

end
