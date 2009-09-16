%  ############################################################################
%  #    GNU Oflox Copyright (C) 2006, 2007, 2008, 2009 by Andres Sajo         #
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
% NAME:
%          GNU oflox -- Simplex FMC implementation with aims to academic use.
%
% SYNAPSIS:
%          function [Z, flow, iter, iterF1] = oflox (
%          filename,
%          config = struct( % Default values follow
%                          'sol0'            , {false},
%                          'FASE1'           , {false},
%                          'BIGM'            , {true},
%                          'latex'           , {false},
%                          'aname'           , {'noname'},
%                          'scale'           , {0.5},
%                          'lang'            , {'en'},
%                          'color_arc'       , {'#000000'},
%                          'color_l'         , {'#8D0000'},
%                          'color_u'         , {'#00C000'},
%                          'color_art'       , {'#FF6A00'},
%                          'color_thr'       , {'#AAAAFF'},
%                          'color_pot'       , {'#DA03D7'},
%                          'show_thread'     , {false},
%                          'show_depth'      , {false},
%                          'compiledvi'      , {false},
%                          'it_info'         , {-1}
%          )
%
%          filename:           is a DIMACS CHALLENGE MIN EXTENDED FORMAT network, for more information
%                              on this format please consult the ``dimacs.extended'' file.
%
%          config.sol0:        Boolean value indicating wether to use or not the initial feaseble
%                              solution defined in ``filename''. Defaults to false.
%
%          config.FASE1:       Boolean value indicating wether the problem should be solved using
%                              FASE 1 / FASE 2. Defaults to false.
%
%          config.BIGM:        Boolean value indicating wether the problem should be solved using Big M.
%                              Defaults to true.
%
%          config.latex:       Boolean value indicating wether to output latex code or not. Default to
%                              false.
%
%          config.compiledvi:  Boolean value indicating wether to compile to DVI and PDF the \LaTeX
%                              generated source. This switch is only relevant is config.latex is true.
%
%          config.aname:       String specifying the latex output file pattern. Default to 'noname'.
%
%          config.scale:       float specifying the scale factor of the dot generated graphs used by
%                              \includegraphics[scale=0.5]{...}. This switch is only used if
%                              config.latex is true. Default to '0.5'.
%
%          config.lang:        Two coded caracters specifying the latex output language. Languages
%                              currently supported are:
%                                 English ``en'' (default)
%                                 Spanish ``es''
%
%          config.color_arc:   The color of the arcs in HTML coded color. Defaults to black (#000000).
%
%          config.color_l:     The color of arcs in lower bound in HTML coded color. Defaults to
%                              red (#8D0000).
%
%          config.color_u:     The color of arcs in upper bound in HTML coded color. Defaults to
%                              green (#00C000).
%
%          config.color_art:   The color of artificial arcs in HTML coded color. Defaults to
%                              orange (#FF6A00).
%
%          config.color_thr:   The color of the THREAD array (when displayed by config.show_thread=true).
%                              Default to blue (#AAAAFF).
%
%          config.color_pot:   The color of the arcs that enters and leaves the tree on the same iteration.
%                              Defaults to magenta (#DA03D7).
%
%          config.show_thread: Boolean value specifying wether to display the thread array on the tree
%                              graph. Defaults to false.
%
%          config.show_depth:  Boolean value specifying wether to display the depth array on the tree graph.
%                              Defaults to false.
%
%          config.it_info:     This switch indicates that the information of a specific iteration is desired.
%                              The iteration information is displayed in DIMACS min extended format ready to
%                              be included in a DIMACS min extended file. Once displayed the information the
%                              iterations are stopped. If the value is less than 0 then no information is
%                              displayed. Defaults to -1.
%
%
%          NOTE: The switches config.FASE1 and config.BIGM are mutually exclusive and are ignored if config.sol0 is set to true.
%
% VERSION:
%          1.0.1 15/09/2009 Moved to google-code and Octave packege inst
%          1.0 RC-7 14/09/09 first public release google-code import
%          1.0 RC-6 31/08/2009 almost ready for the public!
%          1.0 Beta 4 Big-M 24/08/2009 <- The BIG-jiM Code!
%          version 1.0 BETA 2 incorporates a better latex/dvi interface
%          oflox moves to GNU oflox version 1.0 BETA +06/08/2009+
%          1.0+second release 03/11/2008+
%          1.0+first release 25/10/2008+
%          1.0+fix 1 230908+
%
% DATE:
%          18/11/2006, 03/08/2008, 26/06/2009, 15/09/2009
%
% DESCRIPTION:
%          Simplex FMC implementation. It is not a production purpose code and it is intended for educational purpose.
%
% AUTHOR:
%          Andrew Sajo, http://code.google.com/p/gnuoflox/
%          Universidad Simón Bolívar
%          Coordinación de Matematicas
%          Departamento de Cómputo Científico y Estadística
%          Caracas, Venezuela.
%
% BUGS:
%          Please report bugs to talassio.at.gmail.dot.com
%
% COPYRIGHT:
%          This software is released with the GLP version 3 license
%
% KUDOS:
%          To my tutor Professor B. Feijoo
%
% CONTRIBUTORS:
%
%
function [Z, flow, iter, iterF1] = oflox(
        filename,
        config = struct( % Default values follow
                        'sol0'            , {false},
                        'FASE1'           , {false},
                        'BIGM'            , {true},
                        'latex'           , {false},
                        'aname'           , {'noname'},
                        'scale'           , {0.5},
                        'lang'            , {'en'},
                        'color_arc'       , {'#000000'},
                        'color_l'         , {'#8D0000'},
                        'color_u'         , {'#00C000'},
                        'color_art'       , {'#FF6A00'},
                        'color_thr'       , {'#AAAAFF'},
                        'color_pot'       , {'#DA03D7'},
                        'show_thread'     , {false},
                        'show_depth'      , {false},
                        'compiledvi'      , {false},
                        'it_info'         , {-1}
        )
)

global debug;
debug = true;

% STAR Variables
global A;
global DE;
global TLU;
global X;
global C;
global U;
global AP;
global AR;
global TRAZA;
global ARCCLASS; % Arc Class: natural (0), artificial (1)

% TPD
global FLOX_PRED;
global DEPTH;
global THREAD;

% Potentials
global CPI;
global PI;

% Problem
global B;
global NODOS;
global ARCOS;
global ROOT;

% Miscelaneous
global CANDIDATE;
global MO; % Multiple Outputs

% START OF PROGRAM

MO = config;
iterF1 = 0;
master = ''; % Master \LaTeX file

if ( ( MO.FASE1 == true ) & ( MO.BIGM == true ) ), error("Can't use FASE-I and Big-M methods simultaneously! Choose only one."); end;

read_dimacs_min(filename); %% TODO See if there is EXTENDED INFO
if ( length(B) ~= NODOS ) error("Could not read DIMACS MIN file correctly."); end;

OLD_C = C;
if ( sum(B) ~= 0 ), error("Problem is not balanced."); end;

if ( config.sol0 == true ),
        if ( config.FASE1 == true ),
                warning('Ignoring FASE1 parameter value.');
                config.FASE1 = false;
        end
        if ( config.BIGM == true ),
                warning('Ignoring BIGM parameter value.');
                config.BIGM = false;
        end
        %
        % get initial and do POST checks, ready for FASE 2.
        %
        % See if the read_dimacs_min found extra info...
        if (sum(TLU==0) ~= (NODOS-1)), error("Something is wrong, specified initial solution is not complete."); end;

end

% Print out the description of the problem to resolve WARNING:
% X shows the initial_solution FLOW if the switch is true.
% Before this we need to see if it is a feasable solution!!!!!
if ( config.latex == true ), mo(config.aname, -1, 0, 0, X, 2, 0); end;

if ( ( config.FASE1 == true ) | ( config.BIGM == true ) ), % DO FASE 1 or BIGM

        if ( config.FASE1 == true ),
                fase_one;
        else
                bigm;
        end;
        calflu;
        calpi;
        iter = 0;
        ced = 0;
        sal = 0;
        oldX = zeros(length(X), 1);

        if ( config.latex == true ),
                if ( config.FASE1 == true ),
                        afilename = strcat('F1-', config.aname);
                else
                        afilename = strcat('M-', config.aname);
                end;
                mo(afilename, 0, 0, 0, X, 0, 0);
                mo(afilename, 0, 0, 0, 0, -2, 0);
        else
                afilename = '';
        end

        while (tablav(afilename, iter)),
                iter = iter + 1;
                if ( CANDIDATE(1) == 0 ), error('There is no arc inbound to the TREE! (see function tablav)');
                else
                        ced = CANDIDATE(1);
                end

                % Identify cicle and update flows
                % Show the outbound arc and the new flows
                oldX = X;
                [X vardelta]= actflu(ced); % HERE WE modify X. [artificial arc is removed from the TREE and from STAR arrays]

                % We introduce arc ``ced'' in the TREE
                TLU_entrante = TLU(ced);
                TLU(ced) = 0;

                % Take out of the TREE arc ``sal'' and put it in L or U (if it is natural) if not remove altogether
                % (this last is done later):
                if ( CANDIDATE(1) == 0 ), error('There is no OUTBOUND arc! (see function actlu)');
                else
                        sal = CANDIDATE(1);
                end

                if (X(sal) == U(sal)),
                        TLU(sal) = 1; % Goes to partition U.
                else
                        TLU(sal) = -1; % Goes to partition L.
                end

                % Print the current state:
                if ( MO.latex == true ), mo(afilename, iter, ced, sal, oldX, TLU_entrante, vardelta); end;

                % Now we recalculate the potentials PI of the sub-tree only on the branch that does not contain the ROOT node
                % Step 1 / 2: Add the flox update
                if ( ced ~= sal ),
                        PI = actpi(ced, sal); % HERE WE MODIFY PI!
                        % Introduce arc (i, j) in T: THIS IS DONE AFTER UPDATING POTENTIALS!
                        %% BUGFIX070708 moved to line ~109: TLU(ced) = 0;
                        % Update PRED THREAD and DEPTH arrays
                        actTPD(DE(ced), A(ced), DE(sal), A(sal));
                end;

                % Step 2 / 2: Add the new TPD and PI
                if ( config.latex == true ), mo(afilename, iter, 0, 0, 0, -2, 0); end;

                CPI(ced) = 0;

                if ( ARCCLASS(sal) ~= 0 ), % Take out artificial arc from STAR
                        if ( X(sal) > 0 ), error('BUG! Removing an artificial arc with positive flow!'); end;
                        rm_from_estrella(sal);
                end
        end;


        % MO output is not an iteration per se, but the description of the final FASE 1 solution.
        % Note the parameter 2, indicating that the outbound arc does
        % not belong to the TLU array.
        if ( config.latex == true ), mo(afilename, iter+1, 0, 0, X, 2, 0); end

        if ( config.FASE1 == true ),
                iterF1 = iter;
        end;

        %  if (debug),
        %          printf("FASE 1 Information:\nCompleted in %i iterations\n", iter);
        %          disp("Cost Z =");
        %          disp(C'*X);
        %  end;

        % POST FASE I | BIGM
        % Check if there are artificial arcs in T:
        % if flows ~= 0,
        %               problem is not feasible
        % if flows == 0,
        %               replace the arcs in T by naturals one, this is always posible.
        % goto fase two

        if ( sum(X(find(ARCCLASS==1))) ~= 0 ),
                error('The problem is not feasible: there are artificial arcs with positive flow in the Tree.');
        end;
        if (sum(ARCCLASS) > 0), rm_artificials(); end;
        if ( length(C) ~= length(OLD_C) ), error('BUG! Cost vector size mismatch! C ~= OLD_C. Please report.'); end;

        if ( config.BIGM == true ),
                Z = C'*X;
                flow = X;
                % Skip to the end of the file
        else
                C = OLD_C;
                OLD_C = 0;
        end;
else % ( sol0 == true )
        error('GOT INITIAL SOLUTION');
        % Verify is sol0 is feasable!
        % CALPI (this is done in read_dimacs_min();)
        % CALFLU (updates the B's)
end

if (config.BIGM == false), % This goes down to the end of FASE 2
% FASE II
ced = 0;
sal = 0;
calflu;
calpi;
iter = 0;
ced = 0;
sal = 0;
oldX = zeros(length(X), 1);
TLU_entrante = 2;
moname = '';

% Show the initial FASE II problem:
if (config.latex == true),
        moname = config.aname;
        mo(moname, iter, 0, 0, X, 2, 0);
        mo(moname, iter, 0, 0, 0, -2, 0);
end;


while (tablav(moname, iter)),
%          printf("= FASE 2 (iteration: %i) =\n", iter);
        if (iter == config.it_info),
                Z = C'*X;
                flow = X;
                printf("Add the following to the END of the file: %s\n", filename);
                printf("c Information for iteration %i, current cost z = %i\n", iter, Z);
                printf("c FROM TO FLOW (TREE arcs)\n", filename);
                printf("t %i %i %i\n", [DE(TLU==0), A(TLU==0), X(TLU==0)]');
                if (sum(TLU==1) ~= 0), % Add UPPER elements
                        printf("c FROM TO (UPPER arcs)\n", filename);
                        printf("u %i %i\n", [DE(TLU==1) A(TLU==1)]');
                end;
                printf("c End\n");
                return;
        end;
        iter = iter + 1;
        if ( CANDIDATE(1) == 0 ), error('There is no arc inbound to the TREE! (see function TABLAV)'); end;

        ced = CANDIDATE(1);
        oldX = X;
        [X vardelta] = actflu(ced);
        TLU_entrante = TLU(ced);
        TLU(ced) = 0;

        if ( CANDIDATE(1) == 0 ), error('There is no outbound arc from the TREE! (see function ACTLU)'); end;
        sal = CANDIDATE(1);

        if (X(sal) == U(sal)),
                TLU(sal) = 1; % U.
        else
                TLU(sal) = -1; % L.
        end

        % Step 1 / 2: Add the flox update
        if ( config.latex == true ), mo(config.aname, iter, ced, sal, oldX, TLU_entrante, vardelta); end;

        if (ced ~= sal),
                PI = actpi(ced, sal);
                actTPD(DE(ced), A(ced), DE(sal),A(sal));
        end;
        CPI(ced) = 0;
        % Step 2 / 2: Add the new TPD and PI
        if ( config.latex == true ), mo(config.aname, iter, 0, 0, 0, -2, 0); end;

end;

ced=0;
sal=0;

% MO output is not an iteration per se, but the description of the final solution.
% Note the parameter 2, indicating that the outbound arc does
% not belong to the TLU array.
if ( config.latex == true ), mo(config.aname, iter+1, 0, 0, X, 2, 0); end

flow = X;
Z = C'*X;

end; % End of FASE 2 loop

if ( config.latex == true ), % Post process the dot files and write master \LaTeX file.
        warning('Using the SYSTEM call.');
% Master \LaTeX file
        master = strcat('master_', config.aname, '.tex');
        motexpath = which oflox;
        motexpath = strcat(motexpath(1:(length(motexpath)-2)), '_mo.tex');
        system(strcat('cp -v ', motexpath, ' ', master));
        [fid, message] = fopen(master, 'a');
        if (fid == -1)
                error('Could not open master latex output file: %s', master);
        end

        % Setup the output language:
        fprintf(fid, "\n%%Language definition:\n\
\\newcommand{\\FMCiterlabel}{\\FMCiterlabel%s}\n\
\\newcommand{\\FMCproblemlabel}{\\FMCproblemlabel%s}\n\
\\newcommand{\\FMCinitiallabel}{\\FMCinitiallabel%s}\n\
\\newcommand{\\FMCfinallabel}{\\FMCfinallabel%s}\n\
\\newcommand{\\FMCcaption}{\\FMCcaption%s}\n\n\\begin{document}", config.lang, config.lang, config.lang, config.lang, config.lang);

        % The problem description:
        fprintf(fid, '\\FMCname{%s}\n\\begin{figure*}\n\\FMCdescription{%f}{%s}\n\\end{figure*} \\clearpage\n\n',
        config.aname, config.scale, '***1');

        if ( config.FASE1 == true ),
                cmdstring = strcat('for FILE in F1-', config.aname, '*.dot; do dot -Tps "$FILE" -o ${FILE%.dot}.ps ; rm "$FILE" ; done');
                system(cmdstring);
                % Change to FASE 1
                fprintf(fid, '\\FMCname{%s}\n', strcat('F1-', config.aname));
                fprintf(fid, '\\begin{figure*}\n\\FMCinit{%f}{%s}\n\\end{figure*} \\clearpage\n\n', config.scale, '***2');
                for ( i = 1 : iterF1 )
                        fprintf(fid, '\\begin{figure*}\n\\FMCiter{%f}{%s}\n\\end{figure*} \\clearpage\n\n',
                        config.scale, '***3');
                end;
                fprintf(fid, '\\begin{figure*}\n\\FMCsolution{%f}{%s}\n\\end{figure*} \\clearpage\n\n', config.scale, '***4');
        elseif ( config.BIGM == true ),
                cmdstring = strcat('for FILE in M-', config.aname, '*.dot; do dot -Tps "$FILE" -o ${FILE%.dot}.ps ; rm "$FILE" ; done');
                system(cmdstring);
                % Change to BIGM
                fprintf(fid, '\\FMCname{%s}\n', strcat('M-', config.aname));
                fprintf(fid, '\\begin{figure*}\n\\FMCinit{%f}{%s}\n\\end{figure*} \\clearpage\n\n', config.scale, '***2');
                for ( i = 1 : iter )
                        fprintf(fid, '\\begin{figure*}\n\\FMCiter{%f}{%s}\n\\end{figure*} \\clearpage\n\n',
                        config.scale, '***3');
                end;
                fprintf(fid, '\\begin{figure*}\n\\FMCsolution{%f}{%s}\n\\end{figure*} \\clearpage\n\n', config.scale, '***4');
        end;

        % Compile the problem description: (and othe files if exist...
        cmdstring = strcat('for FILE in ', config.aname, '*.dot; do dot -Tps "$FILE" -o ${FILE%.dot}.ps ; rm "$FILE" ; done');
        system(cmdstring);

        if (config.BIGM == false),
                % Normal output:
                fprintf(fid, '\\FMCname{%s}\n', config.aname);
                fprintf(fid, '\\begin{figure*}\n\\FMCinit{%f}{%s}\n\\end{figure*} \\clearpage\n\n', config.scale, '***5');
                for ( i = 1 : iter )
                        fprintf(fid, '\\begin{figure*}\n\\FMCiter{%f}{%s}\n\\end{figure*} \\clearpage\n\n',
                        config.scale, '***6');
                end;
                fprintf(fid, '\\begin{figure*}\n\\FMCsolution{%f}{%s}\n\\end{figure*} \\clearpage\n\n', config.scale, '***7');
        end;

        fprintf(fid, '\\end{document}\n');
        fclose(fid);

        if (config.compiledvi == true ),
                system(strcat('latex ', master));
                system(strcat('dvipdf master_', config.aname, '.dvi'));
                printf("MO: Master output document %s compiled to %s and %s\n", master, strcat('master_', config.aname, '.dvi'), strcat('master_', config.aname, '.pdf'));
        else
                printf("MO: Master output document is %s\n", master);
        end;
end;


end;

