-module(intro).
-export([double/1, double/2,
         is_cute/1,
         water_state/1,
         distance/2]).


% Satzzeichen:
% . "fertig"
% ; "oder"
% , "und"
%

% Variablen: Großbuchstaben
% Funktionsnamen: Kleinbuchstaben
% double/1  1 Parameter / Stelligkeit 1

% Typespec: (Doku)
-spec double(number()) -> number().
double(X) -> X * 2.

-spec double(number(), number()) -> number().
double(X, Y) -> (X + Y) * 2.

% Datei compilieren und laden:
% c(intro).
 
% Atome (Kleinbuchstaben): mike, ok

% Fallunterscheidung:
% Haustier:
% - Hund - dog -ODER-
% - Katze - cat -ODER-
% - Schlange - snake
-type pet() :: dog | cat | snake.

% Ist ein Haustier niedlich?

-spec is_cute(pet()) -> boolean().
% Eine Gleichung pro Fall:
is_cute(dog) -> true;
is_cute(cat) -> true;
is_cute(snake) -> false;
is_cute(_) -> no_pet.

% is_cute(Pet) ->
%    case Pet of
%        dog -> true;
%        cat -> true;
%        snake -> false
%    end.
% 

% Aggregatzustand von Wasser:
% - fest
% - flüssig
% - gas
-type state() :: solid | liquid | gas.

-type temperature() :: number().

-spec water_state(temperature()) -> state().
% water_state(Temperature) ->
%    if
%        Temperature < 0 -> solid;
%        Temperature < 100 -> liquid;
%        true -> gas
%    end.

water_state(Temperature) when Temperature < 0 ->
    solid;
water_state(Temperature) when Temperature < 100 ->
    liquid;
water_state(_Temperature) -> gas.

% zusammengesetzte Daten:
% Position:
% - X -UND-
% - Y
pos1() -> {15, 7}. % 2-Tupel

-type position() :: {number(), number()}.

% Abstand zwischen 2 Positionen
-spec distance(position(), position()) -> number().
distance(Position1, Position2) ->
    {X1, Y1} = Position1,
    {X2, Y2} = Position2,
    DX = X1 - X2,
    DY = Y1 - Y2,
    math:sqrt(DX*DX + DY*DY).
