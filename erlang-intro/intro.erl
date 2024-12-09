-module(intro).
-export([double/1]).

% . "fertig"
% , "und"
% ; "oder"

% Funktionsnamen klein
% Variablen groß

-spec double(number()) -> number(). 
double(X) -> X * 2.

% Datei in Eshell compilieren und laden:
% c(intro).