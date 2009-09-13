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
function ret = rm_from_estrella(ced)
% NAME: Remove (ced) from STAR
% SYNAPSIS: ret = rm_from_estrella(ced)
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

if ( ARCCLASS(ced) == 0 ), error('RM_FROM_ESTRELLA: Removing a natural arc.'); end;

newDE       = [ DE(1:ced-1); DE(ced+1:ARCOS) ] ;
newA        = [ A(1:ced-1); A(ced+1:ARCOS) ] ;
newC        = [ C(1:ced-1); C(ced+1:ARCOS) ] ;
newARCCLASS = [ ARCCLASS(1:ced-1);ARCCLASS(ced+1:ARCOS) ] ;
newX        = [ X(1:ced-1); X(ced+1:ARCOS) ] ;
newU        = [ U(1:ced-1); U(ced+1:ARCOS) ] ;
newTLU      = [ TLU(1:ced-1); TLU(ced+1:ARCOS) ] ;

% Update
AP(DE(ced)+1:NODOS+1) = AP(DE(ced)+1:NODOS+1) - 1;
DE = newDE;
A  = newA;
C = newC;
ARCCLASS = newARCCLASS;
X  = newX;
U  = newU;
TLU = newTLU;

TRAZA = [];
AR(1) = 1;
for (i = 1:NODOS-1)
        TRAZA = cat(1, TRAZA, find(A==(i)));
        AR(i+1) = AR(i) + sum( A==i );
end
TRAZA = cat(1, TRAZA, find(A==(NODOS)));
AR(NODOS+1) = ARCOS;

ARCOS = ARCOS - 1;

end

