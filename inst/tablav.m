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
function ret = tablav(filetv='', iteration=0)
% NAME: Reduced costs table
% SYNAPSIS: ret = tablav(filetv='', iteration=0)
% VERSION: 1.0
% DATE: 18/11/2006, 03/08/2008
% DESCRIPTION:
%   ret: 0 if found optimum, 1 if L has violations, 2 if U has violations and 3 if both partitios have.

global A;
global DE;
global C;
global TLU;
global PI;
global X;
global CANDIDATE;
global CPI;

global MO;
global mo_lang;

ftv = 0;

if ( ~isempty(filetv) ),
        filetv = strcat(filetv, '_TV', '_', num2str(iteration), '.tex');
        [ftv, message] = fopen(filetv, 'w');
        if (ftv == -1),
                error('TABLAV: opening file [%s, w]:\n\t%s\n', filetv, message);
                return;
        end
end

ret = 0;
CPI = zeros(10, 1);
CANDIDATE = [0, 0];

mL = find(TLU == -1);
mU = find(TLU == 1);

% Violation table for L and U.
if (ftv ~= 0),
        if ( strcmp(MO.lang, 'en') ), % English
                fprintf(ftv, '\\begin{tabular}{ccccccrcrcrcrc}\n\\multicolumn{14}{c}{Reduced Costs Table} \\\\\n\\hline\n');
        elseif (strcmp(MO.lang, 'es') ), % Spanish
                fprintf(ftv, '\\begin{tabular}{ccccccrcrcrcrc}\n\\multicolumn{14}{c}{Tabla de Costos Reducidos} \\\\\n\\hline\n');
        else
                error('TABLAV: Language not yet implemented! Contact the author if you want to contribute!');
        end;
end;

if ( (ftv ~= 0) && (length(mL) > 0) ),
        if ( strcmp(MO.lang, 'en') ), % English
                fprintf(ftv, '\\multicolumn{14}{c}{Set $\\mathcal{L}\\,\\,(c_{ij}^{\\pi}\\ge0)$} \\\\\n');
        elseif ( strcmp(MO.lang, 'es') ), % Spanish
                fprintf(ftv, '\\multicolumn{14}{c}{Conjunto $\\mathcal{L}\\,\\,(c_{ij}^{\\pi}\\ge0)$} \\\\\n');
        else
                error("TABLAV: BUG! Language not defined completely.");
        end;
end;

for k = 1:length(mL);
        i = mL(k);
%          fprintf('(%i, %i): CPI(%i, %i) = PI(%i) - PI(%i) + C(%i, %i) = ', DE(i), A(i), DE(i), A(i), A(i), DE(i), DE(i), A(i));
        CPI(i) = PI(A(i)) - PI(DE(i)) + C(i);
%          fprintf('(%i) - (%i) + (%i) = %i\t\t', PI(A(i)), PI(DE(i)), C(i), CPI(i));
        if (ftv ~= 0), fprintf(ftv, '$\\pi_{%i}$ & - & $\\pi_{%i}$ & + & $c_{%i%i}$ & $=$ & $(%i)$ & $-$ & $(%i)$ & $+$ & $(%i)$ & $=$ & $%i$', A(i), DE(i), DE(i), A(i), PI(A(i)), PI(DE(i)), C(i), CPI(i)); end;
        if (CPI(i) < 0),
%                  fprintf(' (*)\n');
                if (ftv ~= 0), fprintf(ftv, '& $*$ \\\\\n'); end;
                if (abs(CPI(i)) > CANDIDATE(2)),
                        CANDIDATE = [i, abs(CPI(i))];
                end;
                ret = bitor(ret, 1);
        else
                if (ftv ~= 0), fprintf(ftv, ' & \\\\\n'); end;
%                  fprintf('OK!\n');
        end
end

%  fprintf('\nPartition U, (CPI <= 0):\n');
if ( (ftv ~= 0) && (length(mU) > 0) ),
        if ( strcmp(MO.lang, 'en') ), % English
                fprintf(ftv, '\\multicolumn{14}{c}{Set $\\mathcal{U}\\,\\,(c_{ij}^{\\pi}\\le0)$} \\\\\n');
        elseif ( strcmp(MO.lang, 'es') ), % Spanish
                fprintf(ftv, '\\multicolumn{14}{c}{Conjunto $\\mathcal{U}\\,\\,(c_{ij}^{\\pi}\\le0)$} \\\\\n');
        else
                error("TABLAV: BUG! Language not defined completely.");
        end;
end;

for k = 1:length(mU);
        i = mU(k); % i = la cedula del arco violador actual.
%          fprintf('(%i, %i): CPI(%i, %i) = PI(%i) - PI(%i) + C(%i, %i) = ', DE(i), A(i), DE(i), A(i), A(i), DE(i), DE(i), A(i));
        CPI(i) = PI(A(i)) - PI(DE(i)) + C(i);
%          fprintf('(%i) - (%i) + (%i) = %i\t\t', PI(A(i)), PI(DE(i)), C(i), CPI(i));
        if (ftv ~= 0), fprintf(ftv, '$\\pi_{%i}$ & - & $\\pi_{%i}$ & + & $c_{%i%i}$ & $=$ & $(%i)$ & $-$ & $(%i)$ & $+$ & $(%i)$ & $=$ & $%i$', A(i), DE(i), DE(i), A(i), PI(A(i)), PI(DE(i)), C(i), CPI(i)); end;
        if (CPI(i) > 0),
%                  fprintf(' (*)\n');
                if (ftv ~= 0), fprintf(ftv, '& $*$ \\\\\n'); end;
                if (abs(CPI(i)) > CANDIDATE(2)),
                        CANDIDATE = [i, abs(CPI(i))];
                end;
                ret = bitor(ret, 2);
        else
                if (ftv ~= 0), fprintf(ftv, '\\\\\n'); end;
%                  fprintf('OK!\n');
        end
end
%  fprintf('\nSuggestion: the arcs marked by *\n');
%  fprintf('are candidates to enter the TREE.\n');


if (ftv ~= 0),
        fprintf(ftv, '\\hline\n');
        if (CANDIDATE(1) ~= 0),
                % Here we need to signal the entering arc ......
                fprintf(ftv, '\\multicolumn{14}{l}{\\rule{0.0em}{1.0em}\\footnotesize ');
                if ( strcmp(MO.lang, 'en') ) %english
                        fprintf(ftv, 'The arc (%i, %i) enters the tree.}\n', DE(CANDIDATE(1)), A(CANDIDATE(1)));
                elseif ( strcmp(MO.lang, 'es') ), %spanish
                        fprintf(ftv, "El arco (%i, %i) entra al \\\'arbol.}\n", DE(CANDIDATE(1)), A(CANDIDATE(1)));
                else
                        error("TABLAV: BUG! Language not defined completely.");
                end
        end
        fprintf(ftv, '\\end{tabular}');
        fclose(ftv);
end;

%  if ( ret == 0 ),
%          return;
%  end;
%
%  fprintf('** The Dantzig pivot rule  chooses arc: (%i, %i), index=%i, violation=%i\n', DE(CANDIDATE(1)), A(CANDIDATE(1)), CANDIDATE(1), CANDIDATE(2));
