-module(intro).
-export([double/1, double/2,
         is_cute/1, water_state/1]).

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
-type pet() :: dog | cat | snake. 
-spec is_cute(pet()) -> boolean().
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

% Aggregatzustand von Wasser
-spec water_state(number()) -> solid | liquid | gas.
% water_state(Temperature) ->
%    if
%        Temperature < 0 -> solid;
%        Temperature > 100 -> gas;
%        true -> liquid
%    end.
% 
water_state(Temperature) when Temperature < 0 -> solid;
water_state(Temperature) when Temperature > 100 -> gas;
water_state(_Temperature) -> liquid.