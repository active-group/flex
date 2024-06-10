-module(intro).
-export([double/1, double/2,
         is_cute/1,
         water_state/1,
         distance/2,
         safe_divide/2, slope/2,
         dillo1/0, dillo2/0,
         run_over_dillo/1,
         feed_dillo/2,
         list_sum/1,
         run_over_parrot/1,
         run_over_animal/1,
         run_over_animals/1,
         highway/0]).


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
% pos1() -> {15, 7}. % 2-Tupel

-type position() :: {number(), number()}.

% Abstand zwischen 2 Positionen
-spec distance(position(), position()) -> number().
distance(Position1, Position2) ->
    {X1, Y1} = Position1, % pattern matching
    {X2, Y2} = Position2,
    DX = X1 - X2,
    DY = Y1 - Y2,
    math:sqrt(DX*DX + DY*DY).

% Dividieren, aber sicher
-spec safe_divide(number(), number()) -> {ok, number()} | divide_by_zero.
safe_divide(A, B) ->
    if
        B == 0 -> divide_by_zero;
        true -> {ok, A/B}
    end.

% Steigung einer Geraden berechnen
-spec slope(position(), position()) -> {ok, number()} | vertical.
slope({X1, Y1}, {X2, Y2}) ->
    case safe_divide(Y2-Y1, X2-X1) of
        divide_by_zero -> vertical;
        {ok, Slope} -> {ok, Slope}
    end.

% Zusammengesetzte Daten:
% Ein Gürteltier hat die folgenden Eigenschaften:
% - (lebendig -ODER- tot)  -UND-
% - Gewicht

-type liveness() :: dead | alive.
-type weight() :: number().

-record(dillo, { liveness :: liveness(), 
                  weight :: weight() } ).

% lebendiges Gürteltier, 8kg
dillo1() -> #dillo{ liveness = alive, weight = 8 }.
dillo2() -> #dillo{ liveness = dead, weight = 5}.

% Gürteltier überfahren
% run_over_dillo(#dillo{ weight = W }) ->
%    #dillo { liveness = dead, weight = W}.
% 
% run_over_dillo(D) ->
%   D#dillo { liveness = dead }. % Kopie von D, bis auf liveness = dead

-spec run_over_dillo(#dillo{}) -> #dillo{}.
run_over_dillo(D) ->
    #dillo { liveness = dead, weight = D#dillo.weight }.

% Gürteltier füttern, tote Gürteltiere nehmen nicht zu
% variable Menge

-spec feed_dillo(#dillo{}, weight()) -> #dillo{}.
% feed_dillo(#dillo { liveness = L, weight = W}, FoodWeight) ->
%     #dillo { liveness = L, 
%              weight = case L of
%                         alive -> W + FoodWeight;
%                         dead -> W
%                       end
%             }.
% 
feed_dillo(#dillo {liveness = alive, weight = W}, FoodWeight) ->
    #dillo { liveness = alive, weight = W + FoodWeight};
feed_dillo(#dillo { liveness = dead } = Dillo, _FoodWeight) ->
    Dillo.

% Ein Papagei hat:
% - Satz -UND-
% - Gewicht
-record(parrot, { sentence :: string(), weight :: weight() }).

parrot1() -> #parrot{sentence="Hello", weight=1}.
parrot2() -> #parrot{sentence="Goodbye!", weight=2}.

% Papagei überfahren
-spec run_over_parrot(#parrot{}) -> #parrot{}.
run_over_parrot(Parrot) ->
    Parrot#parrot{ sentence = ""}.

% Ein Tier ist eins der folgenden:
% - Gürteltier -ODER-
% - Papagei
-type animal() :: #dillo{} | #parrot{}.

-spec run_over_animal(animal()) -> animal().
run_over_animal(#dillo{} = Dillo) -> run_over_dillo(Dillo);
run_over_animal(#parrot{} = Parrot) -> run_over_parrot(Parrot).

% Eine Liste ist eins der folgenden:
% - die leere Liste [] -ODER-
% - eine Cons-Liste aus erstem Element -UND- Rest-Liste
%   [ First | Rest ]+
%                                                 ^^^^^ Selbstbezug

list0() -> []. % leere Liste
list1() -> [ 5 | [] ]. % 1elementige Liste 5
list2() -> [ 7 | list1() ]. % 2elementige Liste 7 5
list3() -> [musa, christoph, mike]. % 3elementige Liste

list4() -> [2, 5, 4, 9].

% Liste aufsummieren
-spec list_sum(list(number())) -> number().
list_sum([]) -> 0;
list_sum([ First | Rest ]) ->
    First + list_sum(Rest).

highway() -> [dillo1(), dillo2(), parrot1(), parrot2()].

% Tiere überfahren
-spec run_over_animals(list(animal())) -> list(animal()).
run_over_animals([]) -> [];
run_over_animals([ First | Rest ]) ->
    [ run_over_animal(First) | run_over_animals(Rest) ].

% Binary:
% <<"Mike">>
% Array-Repräsentation mit UTF-8

% Alle niedlichen Tiere aus einer Liste von Tieren extrahieren
% 
foo(Pet) ->
    case is_cute(Pet) of
        true -> cute;
        false -> not_cute
    end.

-spec extract_cute_pets(list(pet())) -> list(pet()).
extract_cute_pets([]) -> todo;
extract_cute_pets([ First | Rest ]) ->
    case is_cute(First) of
        true -> [ First | extract_cute_pets(Rest)];
        false -> extract_cute_pets(Rest)
    end. % ... extract_cute_pets(Rest) .