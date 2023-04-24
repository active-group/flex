-module(intro).
-export([double/1]). % /1 Anzahl der Parameter

% . fertig
% ; "oder"
% , "und"

-spec double(string()) -> number().
double(X) -> X * 2.