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
function config = ofloxconfig()

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
        );

end;