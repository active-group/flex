-module(intro).
-export([double/1, is_cute/1, % /1 Anzahl der Parameter
         water_state/1, safe_divide/2]).
% . fertig
% ; "oder"
% , "und"

-spec double(number()) -> number().
double(X) -> X * 2.

% Atom: "konstante Zeichenkette" / Name


% Haustier ist eins der folgenden:
% - Hund - ODER -
% - Katze - ODER -
% - Schlange

% Ist ein Haustier niedlich?
-spec is_cute(dog | cat | snake) -> boolean().
% is_cute(Pet) ->
%    case Pet of
%        dog -> true;
%        cat -> true;
%        snake -> false
%    end.
is_cute(dog) -> true;
is_cute(cat) -> true;
is_cute(snake) -> false.

% Aggregatzustand von Wasser
-spec water_state(number()) -> liquid | solid | gas.
%water_state(Temperature) ->
%    if
%        Temperature < 0 -> solid;
%        Temperature > 100 -> gas;
%        true -> liquid
%    end.
water_state(Temperature) when Temperature < 0 -> solid;
water_state(Temperature) when Temperature > 100 -> gas;
water_state(_Temperature) -> liquid.

% Tupel: {1, true, "Mike"}

safe_divide(X, Y) ->
    if 
        Y == 0 -> ...;
        true -> X / Y
    end.