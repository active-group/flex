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

% Haustier:
% - Hund
% - Katze
% - Schlange

% Ist Haustier niedlich?