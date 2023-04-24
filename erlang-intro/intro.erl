-module(intro).
-export([double/1]). % /1 Anzahl der Parameter

% . fertig
% ; "oder"
% , "und"

-spec double(number()) -> number().
double(X) -> X * 2.

% Atom: "konstante Zeichenkette" / Name
% 

% Haustier ist eins der folgenden:
% - Hund - ODER -
% - Katze - ODER -
% - Schlange
