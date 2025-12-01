-module(intro).
-export([double/1, is_cute/1,
         distance/2, coord1/0]).

% /1, /2: Stelligkeit der Funktion

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

% Tupel aus zwei Zahlen:
-type coord() :: {number(), number()}.

% Koordinate X=5, Y=7
coord1() -> {5, 7}.

% Abstand zwischen zwei Koordination
-spec distance(coord(), coord()) -> number().
%distance({X1, Y1}, {X2, Y2}) -> % Pattern-Matching 
%   math:sqrt((X1-X2) * (X1-X2) + (Y1-Y2) * (Y1-Y2)).
distance ({X1, Y1}, {X2, Y2}) ->
    DX = X1 - X2, % lokale Variable
    DY = Y1 - Y2,
    math:sqrt(DX*DX + DY*DY).