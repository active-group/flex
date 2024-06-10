-module(intro).
-export([double/1, double/2]).

% Satzzeichen:
% . "fertig"
% ; "oder"
% , "und"
%

% Variablen: Großbuchstaben
% Funktionsnamen: Kleinbuchstaben
% 
double(X) -> X * 2.

double(X, Y) -> (X + Y) * 2.