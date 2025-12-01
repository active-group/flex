-module(intro).
-export([double/1, is_cute/1,
         distance/2, coord1/0,
         dillo1/0, dillo2/0,
         run_over_dillo/1, feed_dillo/2,
         parrot1/0, parrot2/0,
         run_over_parrot/1,
         run_over_animal/1,
         is_in/2]).

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

% Tiere auf dem texanischen Highway

% Gürteltier hat folgende Eigenschaften:
% - (lebendig -oder- tot)    -UND-
% - Gewicht
-type liveness() :: alive | dead.
-type weight() :: number().  % in kg

-record(dillo, { liveness :: liveness(),
                 weight :: weight() }).

% lebendiges Gürteltier, 10kg
dillo1() -> #dillo { liveness = alive, weight = 10 }.
% totes Gürteltier, 8kg
dillo2() -> #dillo { liveness = dead, weight = 8}.

-spec run_over_dillo(#dillo{}) -> #dillo{}.
% _: don't care
% run_over_dillo(#dillo { liveness = _L, weight = W}) ->
run_over_dillo(#dillo { weight = W}) ->
    #dillo { liveness = dead, weight = W }.

% Gürteltier füttern
% - Futtermenge spezifizierbar
% - tote Gürteltiere nehmen nicht zu
feed_dillo(#dillo { liveness = alive, weight = Weight}, Amount) ->
    #dillo { liveness = alive,
            weight = Weight + Amount };
feed_dillo(Dillo = #dillo { liveness = dead }, _Amount) ->
           Dillo.
% feed_dillo(Dillo, _) -> Dillo.

% Papagei hat folgende Eigenschaften:
% - Satz    -UND-
% - Gewicht
-record(parrot, { sentence :: string(), weight :: weight() }).

parrot1() -> #parrot { sentence = "Welcome!", weight = 1}.
parrot2() -> #parrot { sentence = "Goodbye!", weight = 2}.

% Papagei überfahren
-spec run_over_parrot(#parrot{}) -> #parrot{}.
run_over_parrot(#parrot { sentence = _Sentence, weight = Weight}) ->
    #parrot { sentence = "", weight = Weight}.

% Tier auf dem texanischen Highway:
% - Gürteltier -ODER-
% - Papagei
-type animal() :: #dillo{} | #parrot{}.

% Tier überfahren
-spec run_over_animal(animal()) -> animal().
run_over_animal(Dillo = #dillo{}) -> run_over_dillo(Dillo);
run_over_animal(Parrot = #parrot{}) -> run_over_parrot(Parrot).

% Eine geometrische Form ("Shape") ist eine der folgenden:
% - Kreis -ODER-
% - Quadrat -ODER-
% - eine Überlagerung zweier geometrischer Formen

% - dafür Typdefinition(en)
% - Funktion, die für einen Punkt herausbekommt, ob er innerhalb oder außerhalb
%   einer geometrischen Form ist.

-record(circle, { center :: coord(),
                  radius :: number() }).
-record(square, { ll_corner :: coord(),
                  side_length :: number}).
-record(overlay, { shape1 :: shape(), shape2 :: shape()}).

-type shape() :: #circle{} | #square{} | #overlay{}.

-spec is_in(shape(), coord()) -> boolean().
is_in(#circle { center = Center, radius = Radius}, Point) ->
    distance(Center, Point) =< Radius;
is_in(#square { ll_corner = {XC, YC}, side_length = SideLength}, {XP, YP}) ->
    XP >= XC andalso 
    XP =< XC + SideLength andalso
    YP >= YC andalso
    YP =< YC + SideLength;
is_in(#overlay { shape1 = Shape1, shape2 = Shape2 }, Point) ->
    is_in(Shape1, Point) orelse is_in(Shape2, Point).


-spec safe_divide(number(), number()) -> {ok, number()} | {error, divide_by_zero}.
safe_divide(X, Y) ->
    if
        Y == 0 -> {error, divide_by_zero};
        true -> {ok, X / Y}
    end.