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
function ret = calflu()
% NAME: Calculates flows for the first time % and shows them
% SYNAPSIS: ret = calflu
% VERSION: 1.0
% DATE: 18/11/2006, 03/08/2008

global ARCOS;
global U;
global B;
global TLU;
global FLOX_PRED;
global THREAD;
global X;
global C;

global A;
global DE;

global debug;

global ARCCLASS;

%  if ( debug ), fprintf('init: calflu.\n'); end

X = zeros(ARCOS, 1); % <--- ojo

% Put flows in L to zero and those of U to upper bound:
X(TLU==-1) = 0;
X(TLU==1) = U(TLU==1); % Easy, no?

% BUGFIX16072008 Check unboundedness: [This never should happen when using FASE 1]
if ( sum(X==inf) ~= 0 ),
        error("CALFLU: The problem is UNBOUNDED.");
end;

% Execute the flows form partition U: NOTE WE MODIFY B !!!!! Cannot be used to verify if sol0 is feasable!
mU = find(TLU==1);
for i = 1:length(mU)
        B(DE(mU(i))) = B(DE(mU(i))) - U(mU(i));
        B(A(mU(i))) = B(A(mU(i))) + U(mU(i));
%          if ( debug )
%                  fprintf('Removing upperbound units of arc (%i, %i) which is %i, from the node %i.\n', DE(mU(i)), A(mU(i)), U(mU(i)), DE(mU(i)));
%                  fprintf('Adding upperbound units of arc (%i, %i) which is %i, to the node %i.\n', DE(mU(i)), A(mU(i)), U(mU(i)), A(mU(i)));
%          end
end

NB = B;
NTLU = TLU;
j = 1; % ROOT;
% NTLU
while (sum(NTLU==0))
        j = find(THREAD == j); % <-----! OPT(4): Change this for an ARCO_THREAD array
        i = FLOX_PRED(j);
        if (i == 0), % error...
                 error("CALFLU: BUG reached the ROOT node!");
        end;
%          if ( debug ), printf('looking in T  for (%i, %i) or (%i, %i)\n', i, j, j, i); end
        T = find( NTLU==0 );

        f = 1;
        for t = 1:length(T),
                if ( ( (i==DE(T(t))) && (j==A(T(t))) ) == 1 ), f = 0; break; end;
                if ( ( (j==DE(T(t))) && (i==A(T(t))) ) == 1 ), f = 0; break; end;
        end
        if ( f ), error("CALFLU: BUG didn\'t find arc in TREE!"); end
        ced = T(t);

%          if (debug), fprintf('leaf %i ced(%i --> %i) = %i [TLU=%i] --> NB(%i) = %i. Assigned flow: ', j, DE(ced), A(ced), ced, NTLU(ced), j, NB(j)); end;
        if (i==DE(ced)),
                if (NTLU(ced) == 0),
                        X(ced) = -NB(j);
                end
        else
                X(ced) = NB(j);
        end

%          if (debug), fprintf('%i.\n', X(ced)); end;

        if (X(ced) < 0), error('CALFLU: BUG Assigned NEGATIVE FLOW!'); end;

        NB(i) = NB(i) + NB(j);

        % if (debug), fprintf('Marcando arreglo con cedula=%i arco (%i, %i).\n', ced, DE(ced), A(ced)); end;
        NTLU(ced) = -100;
        % NTLU
end


%  if (debug),
%          fprintf('\n\nTable of flows:\n');
%          fprintf('arc\tFROM\t--->\tTO\tX\tARCCLASS\n\n');
%          for i = 1:ARCOS
%                  fprintf('%i\t%i\t\t%i\t%i\t%i', i, DE(i), A(i), X(i), ARCCLASS(i));
%                  fprintf('\n');
%          end
%          printf(" *** Z: %i.\n", C'*X);
%  end;
