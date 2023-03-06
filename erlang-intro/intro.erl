-module(intro).
-export([double/1]).

% . fertig
% ; "oder"
% , "und"

% Variablen: fangen mit Großbuchstaben an
% Funktionen: fangen mit Kleinbuchstaben an
% Stelligkeit gehört zum Funktionsnamen dazu
-spec double(number()) -> number().
double(X) -> X * 2.