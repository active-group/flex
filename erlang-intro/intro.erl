-module(intro).
-export([double/1,
         is_cute/1,
         distance/2,
         slope/2,
         dillo1/0, dillo2/0,
         run_over_dillo/1,
         feed_dillo/2,
         parrot1/0, parrot2/0,
         run_over_parrot/1,
         run_over_animal/1,
         is_in/2,
         list1/0, list2/0, list3/0, list4/0,
         list_sum/1,
         list_product/1,
         highway/0,
         run_over_animals/1,
         list_map/2,
         run_over_animals2/1,
         inc_list/1,
         rev/1, rev/2]).

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
% - Gürteltier ODER
% - Papagei

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
% feed_dillo(Dillo = #dillo { liveness = Liveness, weight = Weight}, Amount) ->
%    case Liveness of
%        alive -> #dillo { liveness = alive,
%            weight = Weight + Amount};
%        dead -> Dillo
%    end.

feed_dillo(#dillo { liveness = alive, weight = Weight}, Amount) ->
    #dillo { liveness = alive,
            weight = Weight + Amount };
feed_dillo(Dillo = #dillo { liveness = dead}, _) ->
    Dillo.

% Ein Papagei hat folgende Eigenschafte:
% - Satz -UND-
% - Gewicht
-record(parrot, { sentence :: string(), weight :: weight() }).

% Begrüßungspapagei, 1kg
parrot1() -> #parrot { sentence = "Willkommen!", weight = 1}.
% Verabschiedungspapagei, 2kg
parrot2() -> #parrot { sentence = "Auf Wiedersehen!", weight = 2}.

% Papagei überfahren
-spec run_over_parrot(#parrot{}) -> #parrot{}.
run_over_parrot(#parrot { weight = Weight }) ->
    #parrot { sentence = "", weight = Weight }.

-type animal() :: #dillo{} | #parrot{}.

% Tier überfahren
-spec run_over_animal(animal()) -> animal().
run_over_animal(Dillo = #dillo{}) -> run_over_dillo(Dillo);
run_over_animal(Parrot = #parrot{}) ->
    run_over_parrot(Parrot).

% Eine geometrische Figur ist eins der folgenden:
% - ein Kreis -ODER-
% - ein Quadrat -ODER-
% - eine Überlagerung zweier geometrischer Figuren

% 1. Repräsentation für geometrische Figuren
% 2. Funktion, die feststellt, ob ein Punkt
%    innerhalb oder außerhalb einer geometrischen Figur 
%    liegt.


-record(circle, { center :: coordinates(),
                  radius :: number() }).
-record(square, { ll_corner :: coordinates(),
                  side_length :: number}).
-record(overlay, { shape1 :: shape(), shape2 :: shape()}).

-type shape() :: #circle{} | #square{} | #overlay{}.

-spec is_in(shape(), coordinates()) -> boolean().
is_in(#circle { center = Center, radius = Radius}, Point) ->
    distance(Center, Point) =< Radius;
is_in(#square { ll_corner = {XC, YC}, side_length = SideLength}, {XP, YP}) ->
    XP >= XC andalso 
    XP =< XC + SideLength andalso
    YP >= YC andalso
    YP =< YC + SideLength;
is_in(#overlay { shape1 = Shape1, shape2 = Shape2 }, Point) ->
    is_in(Shape1, Point) orelse is_in(Shape2, Point).

% Eine Liste ist eins der folgenden:
% - die leere Liste [] -ODER-
% - eine Cons-Liste aus erstem Element und Rest-Liste
%                                               ^^^^^ Selbstbezug
%   [ First | Rest ]

% 1elementige Liste: 5
list1() -> [ 5 | []].
% 2elementige Liste: 5 8
list2() -> [5 | [8 | []]].
% 3elementige Liste: 3 5 8
list3() -> [3, 5, 8].
% 4elementige Liste: 6 3 5 8
list4() -> [6 | list3()].

-spec list_sum(list(number())) -> number().
list_sum([]) -> 0;
list_sum([First | Rest]) ->
    First + list_sum(Rest).

-spec list_product(list(number())) -> number().
list_product([]) -> 1;
list_product([ First | Rest ]) ->
    First * list_product(Rest).

highway() -> [dillo1(), dillo2(), parrot1(), parrot2() ].

-spec run_over_animals(list(animal())) -> list(animal()).
run_over_animals([]) -> [];
run_over_animals([ First | Rest ]) ->
    [run_over_animal(First) | run_over_animals(Rest)].

% Binary:
% <<"Mike">>

-spec list_map(fun((A) -> B), list(A)) -> list(B).
list_map(_F, []) -> [];
list_map(F, [ First | Rest]) ->
    [F(First) | list_map(F, Rest)].

run_over_animals2(Animals) ->
    list_map(fun run_over_animal/1, Animals).

inc_list(List) ->
    list_map(fun (N) -> N + 1 end, List).

% Liste der Länge n
% Laufzeit 1 + 2 + 3 + 4 + 5 + ... + (n-1) + n
% (n+1)*n/2 = O(n^2)

-spec rev(list(A)) -> list(A).
rev([]) -> [];
rev([ First | Rest]) ->
    append_element(rev(Rest), First).

-spec append_element(list(A), A) -> list(A).
append_element([], Element) -> [Element];
append_element([ First | Rest], Element) ->
    [ First | append_element(Rest, Element)].

-spec rev(list(A), list(A)) -> list(A).
% "Akkumulator"
rev([], Acc) -> Acc;
rev([ First | Rest], Acc) ->
    rev(Rest, [First | Acc ]).