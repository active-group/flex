-module(intro).
-export([double/1, is_cute/1]).

% Zahl verdoppeln
-spec double(number()) -> number().
double(X) -> X * 2.  % Groß-/Kleinschreibung wichtig

% Datei laden in der Eshell:
% c(intro).
% Ausprobieren:
% intro:double(12).

% . beendet Dinge.

% Haustier ist eins der folgenden:
% - Hund   -ODER-
% - Katze  -ODER-
% - Schlange
% => Fallunterscheidung

% Atom: fängt mit Kleinbuchstaben an

% -> dog, cat, snake repräsentieren Haustiere
-type pet() :: dog | cat | snake.

% Ist Haustier niedlich?
-spec is_cute(pet()) -> boolean().
%is_cute(Pet) ->
%    % Verzweigung: 1 Zweig pro Fall
%    case Pet of
%        dog -> true;  % ; "oder"  (vs. , "und"), muß dazwischen
%        cat -> true;
%        snake -> false % hier kein ;
%    end.
% alternativ 1 Klausel pro Fall:
is_cute(dog) -> true;
is_cute(cat) -> true;
is_cute(snake) -> false.

% Eine 2D-Koordinate besteht aus / hat folgende Eigenschaften:
% - X  -UND-
% - Y
% zusammengesetzte Daten
-type coord() :: {number(), number()}.