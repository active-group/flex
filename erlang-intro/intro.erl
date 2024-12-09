-module(intro).
-export([double/1,
         is_cute/1,
         distance/2,
         slope/2,
         dillo1/0, dillo2/0,
         run_over_dillo/1]).

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
-spec slope(coordinates(), coordinates()) -> {ok, number()} | vertical.
slope({X1, Y1}, {X2, Y2}) ->
    % Verzweigung
    if
        X2 - X1 == 0 -> vertical;
        true -> {ok, (Y2 - Y1) / (X2 / X1)}
    end.

% Tiere auf dem texanischen Highway

% Gürteltier hat folgende Eigenschaften
% - (lebendig oder tot) -UND-
% - Gewicht
% zusammengesetzte Daten

% Die "Lebendigkeit" ist eins der folgenden:
% - lebendig ODER
% - tot
-type liveness() :: alive | dead.
-type weight() :: number().

-record(dillo, { liveness :: liveness(),
                 weight :: weight() }).

% lebendiges Gürteltier, 10kg
dillo1() -> #dillo { liveness = alive, weight = 10 }.
% totes Gürteltier, 8kg
dillo2() -> #dillo { liveness = dead, weight = 8 }.

% Gürteltier überfahren
-spec run_over_dillo(#dillo{}) -> #dillo{}.
% run_over_dillo(#dillo { weight = W} ) ->
%    #dillo { liveness = dead, weight = W}.
% run_over_dillo(Dillo) ->
%     % Dillo kopiert bis auf liveness
%    Dillo#dillo { liveness = dead }.
run_over_dillo(Dillo) ->
    #dillo { liveness = dead, weight = Dillo#dillo.weight }.

% Gürteltier füttern:
% - variable Futtermenge
% - lebendige Gürteltiere nehmen
% - tote Gürteltiere nicht

-spec feed_dillo(#dillo{}, weight()) -> #dillo{}.
feed_dillo(Dillo = #dillo { liveness = Liveness, weight = Weight}, Amount) ->
    case Liveness of
        alive -> #dillo { liveness = alive,
            weight = Weight + Amount};
        dead -> Dillo
    end.