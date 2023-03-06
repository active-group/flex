-module(intro).
-export([double/1, double/2]).

% . fertig
% ; "oder"
% , "und"

% Variablen: fangen mit Großbuchstaben an
% Funktionen: fangen mit Kleinbuchstaben an
% Stelligkeit gehört zum Funktionsnamen dazu
-spec double(number()) -> number().
double(X) -> X * 2.

double(X, Y) -> X * Y * 2.

% Atome: fangen auch mit Kleinbuchstaben an
% "Namen"