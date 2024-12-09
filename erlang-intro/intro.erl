-module(intro).
-export([double/1,
         is_cute/1]).

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

-spec is_cute(pet()) -> boolean().
% eine Klausel/Gleichung pro Fall
is_cute(dog) -> true;
is_cute(cat) -> true;
is_cute(snake) -> false.