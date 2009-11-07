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
%
%
%
% THE FOLLOWING FUNCTION SHOULD BE REPLACED WITH A MORE ROBUST VERSION
%
%
%


function read_dimacs_min(archivo)
% NAME: Reads a DIMACS CHALLENGE FMC format file and loads it to memory
% SYNAPSIS: read_dimacs_min('path/to/file.min')
% VERSION: 1.0
% DATE: 02/08/2008, 03/08/2008
% AUTHOR: Andres Sajo


global A;
global DE;
global TLU;
global CPI;
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
global MO;

global debug;

if (ischar(archivo) == 0)
        error('READ_DIMACS_MIN: Wrong file parameter.');
end

[fid, message] = fopen(archivo, 'r');

if (fid == -1)
        error('READ_DIMACS_MIN: Could not open the file.');
end

a_cnt = 1;
str = "";
NODOS = 0;
ARCOS = 0;
cnt = 0;
de = 0;
a = 0;
l = 0;
u = 0;
c = 0;
idx = 0;
d = 0;
f = 0;

linea = fgetl(fid);
sucess = 0;
while (linea ~= -1),
        if (linea(1)=="c"),
        elseif (linea(1) == "p"),
                sucess = bitor(sucess, 1);
                [str, str, NODOS, ARCOS, cnt] = sscanf(linea, '%s %s %i %i', "C");
                B = zeros(NODOS, 1);
                A = zeros(ARCOS, 1);
                DE = zeros(ARCOS, 1);
                C = zeros(ARCOS, 1);
                U = zeros(ARCOS, 1);
                X = zeros(ARCOS, 1);
                TLU = zeros(ARCOS, 1) -1; % LOWER ALL % +100;
                AP = zeros(NODOS+1, 1);
                AR = zeros(NODOS+1, 1);
                THREAD = B;
                DEPTH = B;
                FLOX_PRED = B;
        elseif (linea(1)=="n"),
                sucess = bitor(sucess, 2);
                [str, idx, d, cnt] = sscanf(linea, '%s %i %i', "C");
                if isempty(d), d = 0; end;
                B(idx) = d;
        elseif (linea(1)=="a"),
                sucess = bitor(sucess, 4);
                [str de a l u c cnt] = sscanf(linea, '%s %i %i %i %i %s', "C");
                A(a_cnt) = a;
                DE(a_cnt) = de;
                if ( l ~= 0 ), error('READ_DIMACS_MIN: Lower arc bound must be zero.'); end;
                U(a_cnt) = u;
                C(a_cnt) = str2num(c);
                a_cnt = a_cnt + 1;
        elseif ( (linea(1)=="t") | (linea(1)=="u") ), % If found then end of DIMACS MIN is reached...
                sucess = bitor(sucess, 8);
                break;
        else
                error('READ_DIMACS_MIN: Unexpected error while reading the input file.');
        end
        linea = fgetl(fid);
end



if (sucess == 7),
        printf("information: The input file is DIMACS Challenge Min format (native)\n");
        fclose(fid);
        if (MO.sol0 == true),
                error('Specified input file does not contain extended tree information.');
        end;
elseif (sucess == 15),
        printf("information: The input file is DIMACS Challenge Min format with extensions\n");
else
        error("READ_DIMACS_MIN: Unexpected input error.");
end;

[DE, index] = sort(DE);
A = A([index]);
C = C([index]);
U = U([index]);

AP(1) = 1;
AR(1) = 1;
TRAZA = [];

for (i = 1:NODOS)
        AP(i+1) = AP(i)+(sum(DE([DE==i])')/i);
        %
        [A([AP(i):AP(i+1)-1]), index] = sort(A([AP(i):AP(i+1)-1]));
        t=C([AP(i):AP(i+1)-1]);
        C([AP(i):AP(i+1)-1])=t(index);
        t=U([AP(i):AP(i+1)-1]);
        U([AP(i):AP(i+1)-1])=t(index);
        AR(i+1) = AR(i)+(sum(A([A==i])')/i);
        %%TRAZA = cat(1, TRAZA, find(A==(i)));
end
for (i = 1:NODOS-1)
           TRAZA = cat(1, TRAZA, find(A==(i)));
end
TRAZA = cat(1, TRAZA, find(A==(NODOS)));

AP(NODOS+1) = ARCOS+1;
AR(NODOS+1) = AP(NODOS+1);

% Set unbounded arcs
U( U <= 0 ) = inf;

if (sucess == 7),
        % printf("file is DIMACS MIN FORMAT read OK.\n");
        return;
else
        if (MO.sol0 == 0),
                printf("information: File contains initial solution information. Ignoring by sol0 = false.\n");
                % printf("file is DIMACS MIN FORMAT read OK.\n");
                return;
        end;
        % printf("reading extended information...\n");
end;

% Now we continue reading the file

while (linea ~= -1),
        if (linea(1)=="c"),
        elseif (linea(1)=="t"),
                sucess = bitor(sucess, 16);
                % [str de a f cnt] = sscanf(linea, '%s %i %i %i %s', "C");
                [str de a cnt] = sscanf(linea, '%s %i %i %s', "C");
                % printf("found extra info, tree element! (%i, %i) with flow=%i\n", de, a, f);
                idx = 0;
                for (i = 0 : AP(de+1)-AP(de)-1)
                        % printf("looking at element %i: %i (%i,%i) =? (%i,%i)\n", i, AP(de)+i, DE(AP(de)+i), A(AP(de)+i), de, a);
                        if ( A(AP(de)+i) == a ),
                                idx = 1;
                                TLU(AP(de)+i) = 0; % TREE
                                % if ( U(AP(de)+i) < f ), error("Arc flow exceeds Arc Upper bound. Wrong initial solution specification."); end;
                                % X(AP(de)+i) = f;
                        end;
                end;
                if (idx ~= 1), error("Specified arc not found. Wrong initial solution specification."); end;
        elseif (linea(1)=="u"),
                [str de a cnt] = sscanf(linea, '%s %i %i %s', "C");
                % printf("found extra info, UPPER element! (%i, %i)\n", de, a);
                idx = 0;
                for (i = 0 : AP(de+1)-AP(de)-1)
                        % printf("looking at element %i: %i (%i,%i) =? (%i,%i)\n", i, AP(de)+i, DE(AP(de)+i), A(AP(de)+i), de, a);
                        if ( A(AP(de)+i) == a ),
                                idx = 1;
                                TLU(AP(de)+i) = 1; % UPPER
                                % X(AP(de)+i) = U(AP(de)+i); % This step will be repeated in CALFLU ...
                        end;
                end;
                if (idx ~= 1), error("Specified arc not found. Wrong initial solution specification."); end;
        else
                error('READ_DIMACS_MIN: Unexpected error while reading the input file.');
        end
        linea = fgetl(fid);
end



if (sucess == 31),
        % printf("file is DIMACS MIN EXTENDED FORMAT read OK!\n");
        fclose(fid);

        % Build the PRED, THREAD and DEPTH ARRAYS
        % DFS
        MARK = zeros(length(B), 1);
        MARK(1) = 1;
        FLOX_PRED(1) = 0;
        DEPTH(1) = 0;
        THREAD(1) = 1;
        next = 1;
        STACK = 1;
        TREE = find(TLU == 0);
        while (length(STACK) > 0),
                i = STACK(1);
                j = 0;
                for t = 1:length(TREE),
                        k = TREE(t);
                        if ( i == A(k) ),
                                j = DE(k);
                        elseif (i == DE(k) ),
                                j = A(k);
                        else,
                                continue;
                        end;
                        if ( MARK(j) == 0 ),
                                MARK(j) = 1;
                                TREE(t) = TREE(end);
                                TREE = TREE(1:end-1);
                                break;
                        end;
                end;
                if (j == 0),
                        STACK = STACK(2:end);
                        continue;
                end;

                FLOX_PRED(j) = i;
                next = next + 1;
                THREAD(j) = next;
                DEPTH(j) = DEPTH(i) + 1;
                STACK = [j; STACK];
        end
        [THREAD, i] = sort(THREAD);
        THREAD(i) = [i(2:end); 1];
        % [[1:NODOS]', FLOX_PRED, DEPTH, THREAD]
        % pause;
        %  error('revisar DFS');
else
        error("READ_DIMACS_MIN: Unexpected reading input error.");
end;

