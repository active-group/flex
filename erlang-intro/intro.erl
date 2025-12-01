-module(intro).
-export([double/1]).

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

% Ist Haustier niedlich?