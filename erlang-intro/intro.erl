-module(intro).
-export([double/1, double/2,
         is_cute/1]).

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

% Ist ein Haustier niedlich?
% Ein Haustier ist eins der folgenden:
% - Hund
% - Katze
% - Schlange
-spec is_cute(dog | cat | snake) -> boolean().
% is_cute(Pet) ->
%    case Pet of
%        dog -> true;
%        cat -> true;
%        snake -> false
%    end.
% 
is_cute(dog) -> true;
is_cute(cat) -> true;
is_cute(snake) -> false.