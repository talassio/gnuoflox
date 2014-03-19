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
function [NX delta]= actflu(ced)
% NAME: Update flows
% SYNAPSIS: out_arc = actflu(arc_in)
% VERSION: 1.0
% DATE: 22/11/2006, 03/08/2008, 25/10/2008
global TLU;
global X;
global DEPTH;
global FLOX_PRED;
global U;
global ARCOS;
global DE;
global A;
global debug;
global C;
global CANDIDATE;

CANDIDATE = [0, 0];
%                 / == 0;  still don't have candidate
% CANDIDATE(2) = <  == 1;  we have an arc that is predominant, no updates required
%                 \ == 2;  we have a candidate but it is not predominant
% at the end CANDIDATE has the id of the out going arc in L/U bound

%  if (debug), fprintf('STEP 1: search of delta:\n'); end;

i = DE(ced);
j = A(ced);
ii = i;
jj = j;
cc = 0;
dw = 0;
NX = X;

cc = ced;
if (ced < 1), error('ACTFLU: Wrong input arc.'); end;

dir_w = TLU(ced);

delta = U(ced);

%  if (debug), fprintf('init actflu:\n'); end

%  if (dir_w > 0), % arco (i, j) comes from U.
%          if (debug),
%                  fprintf('Arc (%i, %i) come from U and can decrease %i units. ', i, j, delta);
%          end
%  elseif (dir_w < 0), % Arc (i, j) comes from L.
%          if (debug),
%                  fprintf('Arc (%i, %i) come from L and can increase %i units. ', i, j, delta);
%          end
%  else
%          error('Arc (%i, %i) comes from T!', i, j);
%  end

if ( dir_w == 0 ), error('ACTFLU: Arc (i, j) comes from the TREE!'); end;

% Here we have the delta of the inbound arc the the direction of the cicle!

% Search of the apix and the restrictive delta:
%  if (debug), printf('delta = %i.\n', delta); end
while (i ~= j),
        if ( DEPTH(i) > DEPTH(j) ),
%                  if (debug), fprintf('DEPTH: i > j:\n'); end;
                k = FLOX_PRED(i);
                [i, delta] = fix_i(i, k, delta, dir_w);
                i = k;
        elseif ( DEPTH(j) > DEPTH(i) ),
%                  if (debug), fprintf('DEPTH: j > i:\n'); end;
                k = FLOX_PRED(j);
                [j, delta] = fix_j(j, k, delta, dir_w);
        else
%                  if (debug), fprintf('DEPTH: i = j:\n'); end;
                k = FLOX_PRED(i);
                [i, delta] = fix_i(i, k, delta, dir_w);
                k = FLOX_PRED(j);
                [j, delta] = fix_j(j, k, delta, dir_w);
        end
end
%  if (debug), fprintf('STEP 1: End: delta = %i\n', delta); end;

if (delta == inf), error('ACTFLU: The problem is unbounded.'); end;

%%%% STEP 2 ================================================
i = ii; j = jj;
%  if (debug), fprintf('\nSTEP 2: flows updates:\n'); end;
if (delta == 0),
        warning("Degenerated iteration detected. The flows don\'t change.");
        % It would be nice not to print NX(i) = NX(i) + 0...
        % if delta is zero, just show the outbound arc candidates
end

if (dir_w > 0),
%          if (debug),
%                  fprintf('Arco (%i, %i) comes from U and can decrease %i units: %i --> %i \n ', i, j, delta, NX(cc), NX(cc) - delta);
%          end
        NX(cc) = NX(cc) - delta;
        if (NX(cc) == 0),
%                   fprintf('*** --> NOTE: Arc inbound (%i, %i) is in LOWER bound. [CHOOSING THIS ARC PREDOMINANTLY]\n', i, j);
                CANDIDATE(1)=ced;
                CANDIDATE(2)=1;
        end
else
%          if (debug),
%                  fprintf('Arc (%i, %i) comes from L and can increase %i units: %i --> %i\n', i, j, delta, NX(cc), NX(cc) + delta);
%          end
        NX(cc) = NX(cc) + delta;
        if (NX(cc) == U(cc)),
%                  fprintf('*** --> NOTE: Arc inbound (%i, %i) is in UPPER bound. [CHOOSING THIS ARC PREDOMINANTLY]\n', i, j);
                CANDIDATE(1)=ced;
                CANDIDATE(2)=1;
        end
end

% Even when delta is 0 we need to execute the following while in order to find/suggest out going arcs (but can be improved)
while (i ~= j),
        if ( DEPTH(i) > DEPTH(j) ),
%                  if (debug), fprintf('DEPTH: i > j:\n'); end;
                k = FLOX_PRED(i);
                [i, NX] = flujo_i(i, k, delta, NX, dir_w);

        elseif ( DEPTH(j) > DEPTH(i) ),
%                  if (debug), fprintf('DEPTH: j > i:\n'); end;
                k = FLOX_PRED(j);
                [j, NX] = flujo_j(j, k, delta, NX, dir_w);

        else
%                  if (debug), fprintf('DEPTH: i = j:\n'); end;

                k = FLOX_PRED(i);
                [i, NX] = flujo_i(i, k, delta, NX, dir_w);

                k = FLOX_PRED(j);
                [j, NX] = flujo_j(j, k, delta, NX, dir_w);



        end
end

%  if (debug), fprintf('STEP 2: END. Delta = %i\n', delta); end;

return;


%%%% ===================
%%%% =    FIX_J(...)   =
%%%% ===================
function [new_j, new_delta] = fix_j(j, k, delta, dir_w)
% direction of *(k, j) with respect to dir_w:
%    (the * indicates that it is assumed (k, j) or (j, k).)
% ONLY FOR THE J SIDE OF THE TREE !!!

global X;
global U;
global debug;

new_delta = delta;
ced = cedula(k, j);

if (ced > 0), %      <---     arc (k, j) exists,
        if (dir_w == 1) %  <--- Direction (k, j) in FAVOR of the cicle
                pre_delta = U(ced) - X(ced);
%                  if (debug), fprintf('Arc (%i, %i): is in favor of W, can increase %i units. ', k, j, pre_delta); end
%                  if (pre_delta == 0) & (debug),
%                          % Show we found a blocking LOWER bound arc!
%                          fprintf('[*] ');
%                  end

        else %             <--- Direction (k, j) AGAINST the cicle
                pre_delta = X(ced);
%                  if (debug), fprintf('Arc (%i, %i): is against of W, can decrease %i units. ', k, j, pre_delta); end
        end
else
        ced = cedula(j, k); % arc (j, k) exists
        if (dir_w == 1) % <--- Direction (j, k) AGAINST the cicle
                pre_delta = X(ced);
%                  if (debug), fprintf('Arc (%i, %i): is against of W, can decrease %i units. ', j, k, pre_delta); end
        else %            <--- Direction (j, k) in FAVOR of the cicle
                pre_delta = U(ced) - X(ced);
%                  if (debug), fprintf('Arc (%i, %i): is in favor of W, can increase %i units. ', j, k, pre_delta); end
%                  if (pre_delta == 0) & (debug),
%                          % Show we found a blocking LOWER bound arc!
%                          fprintf('[*] ');
%                  end
        end
end

if (new_delta > pre_delta),
%          if (debug), fprintf('(delta update %i -> %i) ', new_delta, pre_delta); end
        new_delta = pre_delta;
end

%  if (debug), fprintf('Delta = %i.\n', new_delta); end

new_j = k;


%%%% ====================
%%%% =    FIX_I(...)    =
%%%% ====================
function [new_i, new_delta] = fix_i(i, k, delta, dir_w)
% direction of *(k, i) with respect to dir_w:
%    (the * indicates that it is assumed (k, i) or (i, k).)
% ONLY FOR THE J SIDE OF THE TREE !!!

global X;
global U;
global debug;

new_delta = delta;
ced = cedula(k, i);

if (ced > 0), %      <---     Arc (k, i) exists,
        if (dir_w == -1) %  <--- Direction (k, i) in FAVOR of cicle
                pre_delta = U(ced) - X(ced);
%                  if (debug), fprintf('Arc (%i, %i): is in favor of W, and can increase %i units. ', k, i, pre_delta); end
%                  if (pre_delta == 0) & (debug),
%                          fprintf('[*] ');
%                  end
        else %             <--- Direction (k, i) AGAINST cicle
                pre_delta = X(ced);
%                  if (debug), fprintf('Arco (%i, %i): is against W, and can decrease %i units. ', k, i, pre_delta); end
        end
else
        ced = cedula(i, k); % Arco (i, k) exists
        if (dir_w == -1) % <--- Direction (i, k) AGAINST cicle
                pre_delta = X(ced);
%                  if (debug), fprintf('Arco (%i, %i): is against W, and can decrease %i units. ', i, k, pre_delta); end
        else %            <--- Direction (i, k) in FAVOR of cicle
                pre_delta = U(ced) - X(ced);
%                  if (debug), fprintf('Arc (%i, %i): is in favor of W, and can increase %i units. ', i, k, pre_delta); end
%                  if (pre_delta == 0) & (debug),
%                          fprintf('[*] ');
%                  end
        end
end

if (new_delta > pre_delta),
%          if (debug), fprintf('(delta update %i -> %i) ', new_delta, pre_delta); end
        new_delta = pre_delta;
end

%  if (debug), fprintf('Delta = %i.\n', new_delta); end

new_i = k;


%%%% =====================
%%%% =    FLUJO_J(...)   =
%%%% =====================
function [new_j, NX] = flujo_j(j, k, delta, RX, dir_w)

global X;
global U;
global debug;
global CANDIDATE;

NX = RX;

ced = cedula(k, j);

if (ced > 0), % <---  (k, j) exists,
        if (dir_w == 1) %  <--- Direction (k, j) in FAVOR of cicle
%                  if (debug), fprintf('Arc (%i, %i): is in favor of W, increases %i units: %i --> %i \n ', k, j, delta, NX(ced), NX(ced) + delta); end;
                NX(ced) = NX(ced) + delta;
                if (NX(ced) == U(ced)),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in UPPER bound and can leave the TREE.\n', k, j);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        else  % <--- Direction (k, j) AGAINST cicle
%                  if (debug), fprintf('Arc (%i, %i): is against W, decrease %i units: %i --> %i \n ', k, j, delta, NX(ced), NX(ced) - delta); end;
                % What would be faster: ask if (delta == 0) or just NX = NX + 0 ?
                NX(ced) = NX(ced) - delta;
                if (NX(ced) == 0),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in LOWER bound and can leave the TREE.\n', k, j);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        end
else
        ced = cedula(j, k); % (j, k) exists
        if (dir_w == 1) % <--- Direction (j, k) AGAINST cicle
%                  if (debug), fprintf('Arc (%i, %i): is against W, decrease %i units: %i --> %i \n ', j, k, delta, NX(ced), NX(ced) - delta); end;
                % What would be faster: ask if (delta == 0) or just NX = NX + 0 ?
                NX(ced) = NX(ced) - delta;
                if (NX(ced) == 0),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in LOWER bound and can leave the TREE.\n', j, k);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        else % <--- Direction (j, k) in FAVOR of cicle
%                  if (debug), fprintf('Arc (%i, %i): is in favor of W, increases %i units: %i --> %i \n ', j, k, delta, NX(ced), NX(ced) + delta); end;
                NX(ced) = NX(ced) + delta;
                if (NX(ced) == U(ced)),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in UPPER bound and can leave the TREE.\n', j, k);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        end
end
new_j = k;


%%%% =====================
%%%% =   FLUJO_I(...)    =
%%%% =====================
function [new_i, NX] = flujo_i(i, k, delta, RX, dir_w)

global X;
global U;
global debug;
global CANDIDATE;

NX = RX;

ced = cedula(k, i);

if (ced > 0), % <---    (k, i) exists,
        if (dir_w == -1) % <--- Direction (k, i) in FAVOR of cicle
%                  if (debug), fprintf('Arc (%i, %i): in favor of W, increases %i units: %i --> %i \n ', k, i, delta, NX(ced), NX(ced) + delta); end;
                NX(ced) = NX(ced) + delta;
                if (NX(ced) == U(ced)),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in UPPER bound and can leave the TREE.\n', k, i);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        else % <--- Directionn (k, i) AGAINST cicle
%                  if (debug), fprintf('Arc (%i, %i): is against W, decrease %i units: %i --> %i \n ', k, i, delta, NX(ced), NX(ced) - delta); end;
                NX(ced) = NX(ced) - delta;
                if (NX(ced) == 0),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in LOWER bound and can leave the TREE.\n', k, i);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        end
else
        ced = cedula(i, k); % (i, k) exists
        if (dir_w == -1) % <--- Direction (i, k) AGAINST cicle
%                  if (debug), fprintf('Arc (%i, %i): is against W, decrease %i units: %i --> %i \n ', i, k, delta, NX(ced), NX(ced) - delta); end;
                NX(ced) = NX(ced) - delta;
                if (NX(ced) == 0),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in LOWER bound and can leave the TREE.\n', i, k);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        else %            <--- Direction (i, k) in FAVOR of cicle
%                  if (debug), fprintf('Arc (%i, %i): in favor of W, increases %i units: %i --> %i \n ', i, k, delta, NX(ced), NX(ced) + delta); end;
                NX(ced) = NX(ced) + delta;
                if (NX(ced) == U(ced)),
%                          fprintf('*** Sugestion: Arc (%i, %i) is in UPPER bound and can leave the TREE.\n', i, k);
                        if (CANDIDATE(2) ~= 1), CANDIDATE(1)=ced; CANDIDATE(2)=2; end;
                end
        end
end

new_i = k;

function ind = cedula(i, j)

global A;
global AP;
global TLU;

global debug;

ind = 0;

%  if (debug ~= 0), printf('call to cedula(...). searching only in T.\n'); end;

for k = AP(i):AP(i+1)-1
        if ( (A(k) == j) && (TLU(k)==0) ),
%                  if (debug)
%                          printf('Found at position %i TLU[%i]=%i!\n', k, k, TLU(k));
%                  end
                ind = k;
                return;
        end
end
        ind = -1;

