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
function ret = mo(fnamepattern, iteracion, entrante, saliente, oldX, TLU_entrante, delta)
% NAME: Multiple Outputs (MO)
% VERSION: 1.0
% DATE: 02/08/2008, 03/08/2008, 30/06/2009, 01/07/2010
% DESCRIPTION:
%   Function prints to \LaTeX and dot formats all information regarding a given iteration, except the reduced cost table
%   which is done by tablav() function.
%   output files are: [F1|M-]<fnamepattern>_<iteracion>[a].{dot|tex}
%   for the function tablav() the output is: [F1|M-]<fnamepattern>_TV_<iteracion>.tex, at the end of the problem there will be:
%   ``iter'' files [F1|M-]<fnamepattern>_<iteracion>.{dot|tex} and
%   ``iter-1'' files  [F1|M-]<fnamepattern>_TV_<iteracion>.tex and [F1|M-]<fnamepattern>_<iteracion>a.tex, and
%   1 file fnamepattern.{dot|tex} describing the problem
% BUG FIX

% Configuration vars, eye candy:
nodesep = 0.66;
ranksep = 0.66;
noderad = 0.40;
arrowsz = 0.50;


global debug;

global NODOS;
global ARCOS;
global C;
global U;
global X;
global DE;
global A;

global TLU;
global FLOX_PRED;
global DEPTH;
global THREAD;
global PI
global CPI;

global B

global ROOT;
global ARCCLASS;

global MO;

global BIGMCOST;

t = 0;

if (iteracion == -1) % Only print out the problem and return
        filedot = strcat(fnamepattern, '.dot');
        filetex = strcat(fnamepattern, '.tex');
        header = strcat('digraph initialization {\ngraph [center=1,nodesep=',num2str(nodesep),',ranksep=',num2str(ranksep),']\n');
elseif (iteracion == -2) % Only print the MAIN \LaTeX file and return
        error('This call is deprecated')
else
        filedot = strcat(fnamepattern, '_', num2str(iteracion), '.dot');
        filetex = strcat(fnamepattern, '_', num2str(iteracion), '.tex');
        filedotA = strcat(fnamepattern, '_', num2str(iteracion-1), 'a.dot');
        header = strcat('digraph iter', num2str(iteracion),' {\ngraph [center=1,nodesep=',num2str(nodesep),',ranksep=',num2str(ranksep),']\n');
end
if (ischar(filedot) == 0),
        error('MO: filedot description is not valid.');
end

if (ischar(filetex) == 0),
        error('MO: filetex description is not valid.');
end

if (TLU_entrante >= -1), % if TLU_entrante is less than LOWER (== -1) then we ONLY need to print to tex the new TPD and PI vectors

        [fdot, message] = fopen(filedot, 'w');
        if (fdot == -1)
                error('MO: could not open [%s, w]:\n\t%s\n', filedot, message);
        end

        [ftex, message] = fopen(filetex, 'w');
        if (ftex == -1),
                error('MO: could not open [%s, w]:\n\t%s\n', filetex, message);
        end

        fprintf(fdot, header);

        if (iteracion == -1),
                fprintf(fdot, 'node [width=%0.3f, height=%0.3f, fixedsize=true, style=solid] \nedge [arrowsize=%0.3f]\n\n', noderad, noderad, arrowsz);
                for i = 1:ARCOS
                        fprintf(fdot, "    "); fprintf(fdot, "%i -> %i\n", DE(i), A(i));
                end
                fprintf(fdot, "\n/* octave bug? */ }  \n");
                fclose(fdot);

                if ( strcmp(MO.lang, 'en') ), % English
                        fprintf(ftex, '\\begin{tabular}{|c|r|r|}\n\\hline\n arc & \\multicolumn{1}{c|}{$c_{ij}$} & \\multicolumn{1}{c|}{$u_{ij}$}\\\\\n\\hline\n\\hline\n');
                elseif (strcmp(MO.lang, 'es') ), % Spanish
                        fprintf(ftex, '\\begin{tabular}{|c|r|r|}\n\\hline\n arco & \\multicolumn{1}{c|}{$c_{ij}$} & \\multicolumn{1}{c|}{$u_{ij}$}\\\\\n\\hline\n\\hline\n');
                else
                        error('MO: Language not yet implemented! Contact the author if you want to contribute!');
                end;
                for i = 1:ARCOS
                        if ( U(i) == inf ),
                                fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\infty$ \\\\\n', DE(i), A(i), C(i));
                        else
                                fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $%i$ \\\\\n', DE(i), A(i), C(i), U(i));
                        end
                end
                fprintf(ftex, '\\hline\n\\end{tabular}\n');

                fprintf(ftex, '\\hspace{\\FMCtblseparation}\n');

                if ( strcmp(MO.lang, 'en') ), % English
                        fprintf(ftex, '\\begin{tabular}{|c|r|}\n\\hline\n node & \\multicolumn{1}{c|}{$b_{i}$} \\\\\n\\hline\n\\hline\n');
                elseif (strcmp(MO.lang, 'es') ), % Spanish
                        fprintf(ftex, '\\begin{tabular}{|c|r|}\n\\hline\n nodo & \\multicolumn{1}{c|}{$b_{i}$} \\\\\n\\hline\n\\hline\n');
                else
                        error('MO: Language not yet implemented! Contact the author if you want to contribute!');
                end;

                fprintf(ftex, '    $%i$ & $%i$ \\\\\n', [[1:NODOS]', B]');
                fprintf(ftex, '\\hline\n\\end{tabular}\\hspace{\\FMCtblseparation}\n');

                if ( strcmp(MO.lang, 'en') ), % English
                        fprintf(ftex, '\\begin{tabular}{cl}\n \\multicolumn{2}{c}{Legend} \\\\\n Arc color & \\multicolumn{1}{c}{Description} \\\\\n \\hline\n')
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Natural arc \\\\\n", MO.color_arc(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Artificial arc \\\\\n", MO.color_art(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Swapping arc \\\\\n", MO.color_pot(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Natural arc in  $\\mathcal{L}$ set\\\\\n", MO.color_l(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Natural arc in $\\mathcal{U}$ set\\\\\n", MO.color_u(2:7));
                        if ( MO.show_thread == true ),
                                fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Thread array\\\\\n", MO.color_thr(2:7));
                        end;
                        fprintf(ftex, "\\hline\n       \\multicolumn{2}{l}{Dashed arcs enter the Tree}\\\\\n");
                        fprintf(ftex, "       \\multicolumn{2}{l}{Dotted arcs leave the Tree}\\\\\n");
                elseif (strcmp(MO.lang, 'es') ), % Spanish
                        fprintf(ftex, "\\begin{tabular}{cl}\n \\multicolumn{2}{c}{Leyenda} \\\\\n  Color del arco & \\multicolumn{1}{c}{Descripci\\\'on} \\\\\n  \\hline\n")
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Arco natural\\\\\n", MO.color_arc(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Arco artificial\\\\\n", MO.color_art(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Arco de intercambio\\\\\n", MO.color_pot(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Arco natural en el conjunto $\\mathcal{L}$\\\\\n", MO.color_l(2:7));
                        fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Arco natural en el conjunto $\\mathcal{U}$\\\\\n", MO.color_u(2:7));
                        if ( MO.show_thread == true ),
                                fprintf(ftex, "       \\color[HTML]{%s}{\\rule[0.5ex]{2.5em}{1pt}} & Arreglo thread\\\\\n", MO.color_thr(2:7));
                        end;
                        fprintf(ftex, "\\hline\n       \\multicolumn{2}{l}{Arcos con l\\\'inea discont\\\'inua entran al \\\'arbol}\\\\\n");
                        fprintf(ftex, "       \\multicolumn{2}{l}{Arcos punteados salen del \\\'arbol}\\\\\n");
                else
                        error('MO: Language not yet implemented! Contact the author if you want to contribute!');
                end;
                fprintf(ftex, '\\hline\n\\end{tabular}\\vspace{\\FMCvspace}\n');

                fclose(ftex);
                return;
        end

        if ( iteracion > 1 ),
                [fdotA, message] = fopen(filedotA, 'w');
                if (fdotA == -1)
                        fclose(fdot);
                        fclose(ftex);
                        error('MO: could not open [%s, w]:\n\t%s\n', filedot, message);
                end;
                fprintf(fdotA, header);
                if ( MO.show_depth == true ), % & ( iteracion >= 0 ) & ( TLU_entrante ~= -2 ),
                        fprintf(fdotA, "node [style=solid, color=white, fontcolor=\"#777777\", fixedsize=true, height=0.4, width=0.4] ");
                else
                        fprintf(fdotA, "node [style=invis, fixedsize=true, height=0.4, width=0.4] ");
                end;
                fprintf(fdotA, "\n r%i [label=%i]", [[0:max(DEPTH)]' [0:max(DEPTH)]']'); fprintf(fdotA, "\n");
                fprintf(fdotA, 'node [width=%0.3f, height=%0.3f, fixedsize=true, style=solid, color=black, fontcolor=black] \nedge [arrowsize=%0.3f]\n\n', noderad, noderad, arrowsz);
                for (i = 0:max(DEPTH)),
                        fprintf(fdotA, "{ rank=same; "); fprintf(fdotA, "%i ", find(DEPTH==i)); fprintf(fdotA, "r%i }\n", i);
                end;
        end;

        if ( MO.show_depth == true ) & ( iteracion == 0 ),
                fprintf(fdot, "node [style=solid, color=white, fontcolor=\"#777777\", fixedsize=true, height=0.4, width=0.4] ");
        else
                fprintf(fdot, "node [style=invis, fixedsize=true, height=0.4, width=0.4] ");
        end;
        fprintf(fdot, "\n r%i [label=%i]", [[0:max(DEPTH)]' [0:max(DEPTH)]']'); fprintf(fdot, "\n");

        fprintf(fdot, 'node [width=%0.3f, height=%0.3f, fixedsize=true, style=solid, color=black, fontcolor=black] \nedge [arrowsize=%0.3f]\n\n', noderad, noderad, arrowsz);
        for (i = 0:max(DEPTH)),
                fprintf(fdot, "{ rank=same; "); fprintf(fdot, "%i ", find(DEPTH==i)); fprintf(fdot, "r%i }\n", i);
        end

        tlu=TLU;
        if (entrante ~= 0),
                tlu(entrante) = TLU_entrante;
        end;
        if (saliente ~= entrante), % No change in base arc moves form L (U) to U (L)
                tlu(saliente) = 0; % Mark it so it is painted as outnound arc...
        end;


        art_color = char(ARCOS, 7);
        for (i = 1:ARCOS),
                if (ARCCLASS(i)),
                        art_color(i, 1:7) = MO.color_art; %'#4ED1DE': Blue;  % FF6A00: Orange
                else
                        art_color(i, 1:7) = MO.color_arc;
                end
        end

        t = find(tlu==0);
        j = ROOT;

        for (i = 1:length(t)),
                fprintf(fdot, "        "); fprintf(fdot, "%i -> %i ", DE(t(i)), A(t(i)));
                if ( iteracion > 1 ),
                        fprintf(fdotA, "        "); fprintf(fdotA, "%i -> %i ", DE(t(i)), A(t(i)));
                end;
                if ( saliente == t(i) ),
                        fprintf(fdot, "[style=dotted, color=\"%s\", weight=100]", art_color(saliente, 1:7));
                        if ( iteracion > 1 ),
                                fprintf(fdotA, "[color=\"%s\", weight=100]", art_color(t(i), 1:7));
                        end;
                else
                        fprintf(fdot, "[color=\"%s\", weight=100]", art_color(t(i), 1:7));
                        if ( iteracion > 1 ),
                                fprintf(fdotA, "[color=\"%s\", weight=100]", art_color(t(i), 1:7));
                        end;
                end
                fprintf(fdot, "\n")
%                  if ( ( MO.show_thread == true ) & ( ( TLU_entrante ~= 2 ) | ( iteracion == 0 ) ) ),
                if ( MO.show_thread == true ),
                        if ( iteracion == 0 ),
                                fprintf(fdot, "        /*THREAD*/ "); fprintf(fdot, "%i -> %i [color=\"%s\", constraint=false, weight=1]\n", j, THREAD(j), MO.color_thr);
                        elseif ( iteracion > 1 ),
                                fprintf(fdotA, "        /*THREAD*/ "); fprintf(fdotA, "%i -> %i [color=\"%s\", constraint=false, weight=1]\n", j, THREAD(j), MO.color_thr);
                        end;
                        j = THREAD(j);
                end
        end

        % Last element of THREAD
%          if ( ( MO.show_thread == true ) & ( ( TLU_entrante ~= 2 ) | ( iteracion == 0 ) ) ),
        if ( MO.show_thread == true ),
                if ( iteracion == 0 ),
                        fprintf(fdot, "        /*THREAD*/ "); fprintf(fdot, "%i -> %i [color=\"%s\", constraint=false, weight=1]\n", j, ROOT, MO.color_thr);
                elseif ( iteracion > 1 ),
                        fprintf(fdotA, "        /*THREAD*/ "); fprintf(fdotA, "%i -> %i [color=\"%s\", constraint=false, weight=1]\n", j, THREAD(j), MO.color_thr);
                end;
        end;

        % Inbound arc:
        if ( entrante ~= 0 ),
                if ( entrante ~= saliente ),
                        fprintf(fdot, "\n        %i -> %i [style=dashed, weight=50]\n", DE(entrante), A(entrante));
                else, % BASE DOES NOT CHANGE
                        fprintf(fdot, "\n        %i -> %i [style=solid color=\"%s\", weight=50]\n", DE(entrante), A(entrante), MO.color_pot);
                end;
        end;

        fprintf(fdot, "\n        edge [style=invis, weight=200] "); fprintf(fdot, "r%i->", 0:max(DEPTH)-1); fprintf(fdot, "r%i ;\n\n", max(DEPTH));
        if ( iteracion > 1 ),
                fprintf(fdotA, "\n        edge [style=invis, weight=200] "); fprintf(fdotA, "r%i->", 0:max(DEPTH)-1); fprintf(fdotA, "r%i ;\n\n", max(DEPTH));
        end;

        % If last iteration (or final solution specifier, then add the lower and upper bound arcs:
        if ( TLU_entrante == 2 ),
                fprintf(fdot, "        edge [style=solid] \n");
                t = find(TLU~=0);
                for (i = 1:length(t)),
                        if ( TLU(t(i)) == -1 ),
                                fprintf(fdot, "        /*LOWER*/ "); fprintf(fdot, "%i -> %i [color=\"%s\", constraint=false, weight=100]\n", DE(t(i)), A(t(i)), MO.color_l);
                        elseif ( TLU(t(i)) == 1),
                                fprintf(fdot, "        /*UPPER*/ "); fprintf(fdot, "%i -> %i [color=\"%s\", constraint=false, weight=100]\n", DE(t(i)), A(t(i)), MO.color_u);
                        else
                                error('TLU array contains unknown specifiers.');
                        end;
                end;
        end;

        fprintf(fdot, "\n/* octave bug? */ }  \n");
        fclose(fdot);

        if ( iteracion > 1 ),
                fprintf(fdotA, "\n/* octave bug? */ }  \n");
                fclose(fdotA);
        end;

        if ( strcmp(MO.lang, 'en') ), % English
        % Insert text belonging to graph previously to first table:
        % Describe what is happening:
                if ( ( entrante ~= 0 ) & ( saliente ~= 0 ) ),
                        if ( entrante == saliente ), %% (A)
                                if ( TLU(entrante) == 1 ),
                                        fprintf(ftex, '{\\footnotesize The arc (%i, %i) reaches its %s bound and is moved to the $\\mathcal{%s}$ set, the tree does not change.}\\\\[\\FMCvspace] \n', DE(entrante), A(entrante), 'upper', 'U');
                                elseif ( TLU(entrante) == -1 ),
                                        fprintf(ftex, '{\\footnotesize The arc (%i, %i) reaches its %s bound and is moved to the $\\mathcal{%s}$ set, the tree does not change.}\\\\[\\FMCvspace] \n', DE(entrante), A(entrante), 'lower', 'L');
                                else
                                        error('Corrupt TLU table.');
                                end;
                        elseif ARCCLASS(saliente) == 0, %% (B.1)
                                if ( TLU(saliente) == 1 ),
                                        fprintf(ftex, '{\\footnotesize The arc (%i, %i) reaches its %s bound and is moved to the $\\mathcal{%s}$ set.}\\\\[\\FMCvspace] \n', DE(saliente), A(saliente), 'upper', 'U');
                                elseif ( TLU(saliente) == -1 ),
                                        fprintf(ftex, '{\\footnotesize The arc (%i, %i) reaches its %s bound and is moved to the $\\mathcal{%s}$ set.}\\\\[\\FMCvspace] \n', DE(saliente), A(saliente), 'lower', 'L');
                                else
                                        error('Corrupt TLU table.');
                                end;
                        elseif ARCCLASS(saliente) == 1, %% (B.2)
                                if ( TLU(saliente) == -1 ),
                                        fprintf(ftex, '{\\footnotesize The artificial arc (%i, %i) reaches its lower bound and is removed from the problem.}\\\\[\\FMCvspace] \n', DE(saliente), A(saliente));
                                else
                                        error('Artificial arc not reaching lower bound.');
                                end;
                        else
                                error('Unexpected MO branch.');
                        end;
                end;
%                  fprintf(ftex, '\\begin{tabular}{|c|c|c|c|r|}\n\\hline\n node & thread & pred & depth & \\multicolumn{1}{c|}{$\\pi$} \\\\\n\\hline\n\\hline\n')
        elseif (strcmp(MO.lang, 'es') ), % Spanish
                if ( ( entrante ~= 0 ) & ( saliente ~= 0 ) ),
                        if ( entrante == saliente ), %% (A)
                                if ( TLU(entrante) == 1 ),
                                        fprintf(ftex, "{\\footnotesize El arco (%i, %i) llega a su cota %s y sale del \\\'arbol para el conjunto $\\mathcal{%s}$, el \\\'arbol no se altera.}\\\\[\\FMCvspace] \n", DE(entrante), A(entrante), 'superior', 'U');
                                elseif ( TLU(entrante) == -1 ),
                                        fprintf(ftex, "{\\footnotesize El arco (%i, %i) llega a su cota %s y sale del \\\'arbol para el conjunto $\\mathcal{%s}$, el \\\'arbol no se altera.}\\\\[\\FMCvspace] \n", DE(entrante), A(entrante), 'inferior', 'L');
                                else
                                        error('Corrupt TLU table.');
                                end;
                        elseif ARCCLASS(saliente) == 0, %% (B.1)
                                if ( TLU(saliente) == 1 ),
                                        fprintf(ftex, "{\\footnotesize El arco (%i, %i) llega a su cota %s y sale del \\\'arbol para el conjunto $\\mathcal{%s}$ .}\\\\[\\FMCvspace] \n", DE(saliente), A(saliente), 'superior', 'U');
                                elseif ( TLU(saliente) == -1 ),
                                        fprintf(ftex, "{\\footnotesize El arco (%i, %i) llega a su cota %s y sale del \\\'arbol para el conjunto $\\mathcal{%s}$ .}\\\\[\\FMCvspace] \n", DE(saliente), A(saliente), 'inferior', 'L');
                                else
                                        error('Corrupt TLU table.');
                                end;
                        elseif ARCCLASS(saliente) == 1, %% (B.2)
                                if ( TLU(saliente) == -1 ),
                                        fprintf(ftex, '{\\footnotesize El arco artificial (%i, %i) llega a su cota inferior y se descarta del problema.}\\\\[\\FMCvspace] \n', DE(saliente), A(saliente));
                                else
                                        error('Artificial arc not reaching lower bound.');
                                end;
                        else
                                error('Unexpected MO branch.');
                        end;
                end;
%                  fprintf(ftex, '\\begin{tabular}{|c|c|c|c|r|}\n\\hline\n nodo & thread & pred & depth & \\multicolumn{1}{c|}{$\\pi$} \\\\\n\\hline\n\\hline\n')
        else
                error('MO: Language not yet implemented! Contact the author if you want to contribute!');
        end;

%          fprintf(ftex, "       $%i$ & $%i$ & $%i$ & $%i$ & $%i$ \\\\\n", [[1:NODOS]', THREAD, FLOX_PRED, DEPTH, PI]');
%          fprintf(ftex, '\\hline\n\\end{tabular}\n');

        tlu_cal = num2str(TLU)(:,1);
        tlu_cal(find(TLU==0)) = 'T';
        tlu_cal(find(TLU==-1)) = 'L';
        tlu_cal(find(TLU==1)) = 'U';

        % Erase the artificial arcs form the E structure only if FASE1 == true:
        if (MO.FASE1 ~= 0 | MO.BIGM ~= 0),
                j = find(TLU==-1);
                for i = 1:length(j),
                        if ( ARCCLASS(j(i)) == 1 ), tlu_cal(j(i)) = ' '; end;
                end
        end;

%          fprintf(ftex, '\\hspace{\\FMCtblseparation}\n');

        % See if this is the first (0) or last (iter+1) iterations, do not display x_k-1.
        if ( ( iteracion == 0 ) | ( TLU_entrante == 2 ) ),
                if ( (iteracion == 0 ) & ( MO.sol0 == false ) ), % Show costs
                        if ( strcmp(MO.lang, 'en') ), % English
                                if (MO.BIGM == false),
                                        fprintf(ftex, '\\begin{tabular}{|c|r|c|c|}\n\\hline\n\\multicolumn{4}{|c|}{$z=%i$}\\\\\n\\hline\n arc & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$ & $c_{ij}$\\\\\n\\hline\n\\hline\n', C'*X);
                                else,
                                        fprintf(ftex, '\\begin{tabular}{|c|r|c|c|}\n\\hline\n\\multicolumn{4}{|c|}{$M=%i, \\, z=%i$}\\\\\n\\hline\n arc & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$ & $c_{ij}$\\\\\n\\hline\n\\hline\n', BIGMCOST, C'*X);
                                end;
                        elseif (strcmp(MO.lang, 'es') ), % Spanish
                                if (MO.BIGM==false),
                                        fprintf(ftex, '\\begin{tabular}{|c|r|c|c|}\n\\hline\n\\multicolumn{4}{|c|}{$z=%i$}\\\\\n\\hline\n arco & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$ & $c_{ij}$\\\\\n\\hline\n\\hline\n', C'*X);
                                else
                                        fprintf(ftex, '\\begin{tabular}{|c|r|c|c|}\n\\hline\n\\multicolumn{4}{|c|}{$M=%i, \\, z=%i$}\\\\\n\\hline\n arco & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$ & $c_{ij}$\\\\\n\\hline\n\\hline\n', BIGMCOST, C'*X);
                                end;
                        else
                                error('MO: Language not yet implemented! Contact the author if you want to contribute!');
                        end;
                else
                        if ( strcmp(MO.lang, 'en') ), % English
                                fprintf(ftex, '\\begin{tabular}{|c|r|c|}\n\\hline\n\\multicolumn{3}{|c|}{$z=%i$}\\\\\n\\hline\n arc & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$\\\\\n\\hline\n\\hline\n', C'*X);
                        elseif (strcmp(MO.lang, 'es') ), % Spanish
                                fprintf(ftex, '\\begin{tabular}{|c|r|c|}\n\\hline\n\\multicolumn{3}{|c|}{$z=%i$}\\\\\n\\hline\n arco & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$\\\\\n\\hline\n\\hline\n', C'*X);
                        else
                                error('MO: Language not yet implemented! Contact the author if you want to contribute!');
                        end;
                end;
        else
                if ( strcmp(MO.lang, 'en') ), % English
                        fprintf(ftex, '\\begin{tabular}{|c|r|r|c|}\n\\hline\n\\multicolumn{4}{|c|}{$z=%i,\\, \\delta=%i$}\\\\\n\\hline\n arc & \\multicolumn{1}{c|}{$x_{ij}^{k-1}$} & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$\\\\\n\\hline\n\\hline\n', C'*X, delta);
                elseif (strcmp(MO.lang, 'es') ), % Spanish
                        fprintf(ftex, '\\begin{tabular}{|c|r|r|c|}\n\\hline\n\\multicolumn{4}{|c|}{$z=%i,\\, \\delta=%i$}\\\\\n\\hline\n arco & \\multicolumn{1}{c|}{$x_{ij}^{k-1}$} & \\multicolumn{1}{c|}{$x_{ij}^{k}$}  &$\\mathbb{E}$\\\\\n\\hline\n\\hline\n', C'*X, delta);
                else
                        error('MO: Language not yet implemented! Contact the author if you want to contribute!');
                end;
        end
        if (sum(ARCCLASS ~= 0)),
                for i = 1:ARCOS,
                        if (ARCCLASS(i) == 1),
                                if ( ( iteracion == 0 ) & ( MO.sol0 == false ) ),
                                        if ( MO.BIGM == true ),
                                                fprintf(ftex, '    ($%i$, $%i$)\\FMCMsymbol & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', DE(i), A(i), X(i), tlu_cal(i), C(i));
                                        else
                                                fprintf(ftex, '    ($%i$, $%i$)\\FMCasymbol & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', DE(i), A(i), X(i), tlu_cal(i), C(i));
                                        end;
                                elseif ( ( iteracion == 0 ) | ( TLU_entrante == 2 ) ),
                                        if ( MO.BIGM == true ),
                                                fprintf(ftex, '    ($%i$, $%i$)\\FMCMsymbol & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), X(i), tlu_cal(i));
                                        else
                                                fprintf(ftex, '    ($%i$, $%i$)\\FMCasymbol & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), X(i), tlu_cal(i));
                                        end;
                                else
                                        if ( MO.BIGM == true ),
                                                fprintf(ftex, '    ($%i$, $%i$)\\FMCMsymbol & $%i$ & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), oldX(i), X(i), tlu_cal(i));
                                        else
                                                fprintf(ftex, '    ($%i$, $%i$)\\FMCasymbol & $%i$ & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), oldX(i), X(i), tlu_cal(i));
                                        end;
                                end;
                        else
                                if ( ( iteracion == 0 ) & ( MO.sol0 == false ) ),
                                        if ( MO.BIGM == true ),
                                                fprintf(ftex, '    ($%i$, $%i$)\\hspace{\\FMCspaceMsymbol} & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', DE(i), A(i), X(i), tlu_cal(i), C(i));
                                        else
                                                fprintf(ftex, '    ($%i$, $%i$)\\hspace{\\FMCspaceasymbol} & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', DE(i), A(i), X(i), tlu_cal(i), C(i));
                                        end;
                                elseif ( ( iteracion == 0 ) | ( TLU_entrante == 2 ) ),
                                        if ( MO.BIGM == true ),
                                                fprintf(ftex, '    ($%i$, $%i$)\\hspace{\\FMCspaceMsymbol} & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), X(i), tlu_cal(i));
                                        else
                                                fprintf(ftex, '    ($%i$, $%i$)\\hspace{\\FMCspaceasymbol} & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), X(i), tlu_cal(i));
                                        end;
                                else
                                        if ( MO.BIGM == true ),
                                                fprintf(ftex, '    ($%i$, $%i$)\\hspace{\\FMCspaceMsymbol} & $%i$ & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), oldX(i), X(i), tlu_cal(i));
                                        else
                                                fprintf(ftex, '    ($%i$, $%i$)\\hspace{\\FMCspaceasymbol} & $%i$ & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), oldX(i), X(i), tlu_cal(i));
                                        end;
                                end;
                        end
                end
        else
%% BUG FIX 01/07/2010
%%
%% <- fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', [DE, A, X, tlu_cal, C]');
%% -> for i = 1:length(DE),
%% ->        fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', DE(i), A(i), X(i), tlu_cal(i), C(i));
%% -> end;


                if ( ( iteracion == 0 ) & ( MO.sol0 == false ) ),
                        for i = 1:length(DE),
                                fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', DE(i), A(i), X(i), tlu_cal(i), C(i));
                        end;
%  %                          fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\mathcal{%c}$ & $%i$\\\\\n', [num2str(DE), num2str(A), num2str(X), tlu_cal, num2str(C)]');
                elseif ( ( iteracion == 0 ) | ( TLU_entrante == 2 ) ),
                        for i = 1:length(DE),
                                fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), X(i), tlu_cal(i));
                        end;
%  %                          fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $\\mathcal{%c}$\\\\\n', [num2str(DE), num2str(A), num2str(X), tlu_cal]');
                else
                        for i = 1:length(DE),
                                fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $%i$ & $\\mathcal{%c}$\\\\\n', DE(i), A(i), oldX(i), X(i), tlu_cal(i));
                        end;
%  %                          fprintf(ftex, '    ($%i$, $%i$) & $%i$ & $%i$ & $\\mathcal{%c}$\\\\\n', [num2str(DE), num2str(A), num2str(oldX), num2str(X), tlu_cal]');
                end;
        end
        fprintf(ftex, '\\hline\n\\end{tabular}\n');

        fprintf(ftex, '\\hspace{\\FMCtblseparation}\n');

%          fclose(ftex);
else,

        [ftex, message] = fopen(filetex, 'a');
        if (ftex == -1),
                error('MO: could not open [%s, w]:\n\t%s\n', filetex, message);
        end
        if ( strcmp(MO.lang, 'en') ), % English
                fprintf(ftex, '\\begin{tabular}{|c|c|c|c|r|}\n\\hline\n node & thread & pred & depth & \\multicolumn{1}{c|}{$\\pi$} \\\\\n\\hline\n\\hline\n')
        elseif (strcmp(MO.lang, 'es') ), % Spanish
                fprintf(ftex, '\\begin{tabular}{|c|c|c|c|r|}\n\\hline\n nodo & thread & pred & depth & \\multicolumn{1}{c|}{$\\pi$} \\\\\n\\hline\n\\hline\n')
        else
                error('MO: Language not yet implemented! Contact the author if you want to contribute!');
        end;
        fprintf(ftex, "       $%i$ & $%i$ & $%i$ & $%i$ & $%i$ \\\\\n", [[1:NODOS]', THREAD, FLOX_PRED, DEPTH, PI]');
        fprintf(ftex, '\\hline\n\\end{tabular}\\vspace{\\FMCvspace}\n');
%          fclose(ftex);
end;

fclose(ftex);
