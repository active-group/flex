-module(intro).
-export([double/1,
         is_cute/1,
         distance/2]).

% . "fertig"
% , "und"
% ; "oder"

% Funktionsnamen klein
% Variablen groß

-spec double(number()) -> number(). 
double(X) -> X * 2.

% Datei in Eshell compilieren und laden:
% c(intro).

% Ist Haustier niedlich?

% Haustier ist eins der folgenden:
% - Hund -ODER-              dog
% - Katze -ODER-             cat
% - Schlange                 snake
% ^^^ Fallunterscheidung
-type pet() :: dog | cat | snake.

% Atome: klein schreiben

-spec is_cute(pet()) -> boolean().
% eine Klausel/Gleichung pro Fall
% is_cute(dog) -> true;
% is_cute(cat) -> true;
% is_cute(snake) -> false.
is_cute(Pet) ->
    case Pet of
        dog -> true;
        cat -> true;
        snake -> false;
        _ -> no_pet % paßt nicht zum spec
    end.

% Eine 2D-Koordinate besteht aus:
% - X
% - Y
% {X, Y}   Tupel
-type coordinates() :: {number(), number()}.

% Abstand zwischen zwei Koordinaten
-spec distance(coordinates(), coordinates()) -> number().
% distance({X1, Y1}, {X2, Y2}) ->
%     math:sqrt((X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2)).

distance(C1, C2) ->
    {X1, Y1} = C1,
    {X2, Y2} = C2,
    DX = X1 - X2,
    DY = Y1 - Y2,
    math:sqrt(DX * DX + DY * DY).

% Steigung einer Geraden
-spec slope(coordinates(), coordinates()) -> number().
slope({X1, Y1}, {X2, Y2}) ->
    (Y2 - Y1) / (X2 - X2). 