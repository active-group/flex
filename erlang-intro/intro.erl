-module(intro).
-export([double/1, is_cute/1,
         water_state/1,
         safe_divide/2,
         slope/2,
         t1/0, minutes_since_midnight/1,
         dillo1/0, dillo2/0,
         run_over_dillo/1,
         feed_dillo/2,
         parrot1/0, parrot2/0,
         run_over_animal/1,
         list_sum/1,
         list_append/2,
         highway/0,
         animal_is_alive/1,
         run_over_animals/1,
         extract_evens/1, is_even/1,
         extract_odds/1, is_odd/1,
         extract/2]).

% Satzzeichen:
% . "fertig"
% ; "oder"
% , "und"

% Variablen fangen mit Großbuchstaben an.
% Funktionen (und Module) mit Kleinbuchstaben.
% Atome mit Kleinbuchstaben.

% Zahl verdoppeln
-spec double(number()) -> number().
double(X) -> X * 2.

% Haustier ist eins der folgenden:
% - Katze -ODER-
% - Hund -ODER-
% - Schlange
% Fallunterscheidung
% -> Aufzählung

% in Erlang abbilden durch Atome:
% cat, dog, snake

-type pet() :: dog | cat | snake.

% Ist ein Haustier niedlich? 
-spec is_cute(pet()) -> boolean().
% is_cute(Pet) ->
%    case Pet of
%        dog -> true;
%        cat -> true;
%        snake -> false
%    end.
is_cute(dog) -> true;
is_cute(cat) -> true;
is_cute(snake) -> false.

% Aggregatzustand von Wasser
-spec water_state(number()) -> solid | liquid | gas.
% water_state(Temperature) ->
%    if
%        Temperature < 0 -> solid;
%        Temperature > 100 -> gas;
%        true -> liquid
%    end.
% 
water_state(Temperature) when Temperature < 0 -> solid;
water_state(Temperature) when Temperature > 100 -> gas;
water_state(_Temperature) -> liquid.

% Eine 2D-Koordinate besteht aus:
% - X-Koordinate -UND-
% - Y-Koordinate
% zusammengesetzte Daten

% repräsentiert als 2-Tupel {X, Y}

% Ad-hoc-zusammengesetzte Daten:
% Tupel {12, ok, "Mike"}

% "sicher dividieren"
-spec safe_divide(number(), number()) -> {ok, number()} | divide_by_zero.
safe_divide(A, B) ->
    if
        B == 0 -> divide_by_zero;
        true -> {ok, A / B}
    end.

% Steigung einer Geraden berechnen
-spec slope({number(), number()}, {number(), number()}) -> {ok, number()} | vertical.
slope({X1, Y1}, {X2, Y2}) ->
    case safe_divide(Y2-Y1, X2-X1) of
        {ok, Slope} -> {ok, Slope};
        divide_by_zero -> vertical
    end.

% Uhrzeit hat folgende Eigenschaften:
% - Stunde -UND-
% - Minute
% zusammengesetzte Daten
-record(time, {hour :: 0..23, 
               minute :: 0..59}).

% "5 nach 12"
t1() -> #time { hour = 12, minute = 5 }.

% Minuten seit Mitternacht
-spec minutes_since_midnight(#time{}) -> non_neg_integer().
% minutes_since_midnight(Time) ->
%    Time#time.hour * 60 +
%    Time#time.minute.
minutes_since_midnight(#time { hour = Hour, minute = Minute}) ->
    Hour * 60 + Minute.

% Tiere auf dem texanischen Highway
% 
% Gürteltier hat folgende Eigenschaften:
% - lebendig oder tot -UND-
% - Gewicht
% zusammengesetzte Daten
-record(dillo, { liveness :: alive | dead,
                 weight :: number()}).
% lebendiges Gürteltier, 10kg
dillo1() -> #dillo { liveness = alive, weight = 10 }.
% totes Gürteltier, 8kg
dillo2() -> #dillo { liveness = dead, weight = 8}.

% Gürteltier überfahren
-spec run_over_dillo(#dillo{}) -> #dillo{}.
% run_over_dillo(#dillo { weight = W }) ->
%    #dillo { liveness = dead, weight = W}.
% "functional update"
run_over_dillo(Dillo) ->
    % Kopie von Dillo bis auf ...
    Dillo#dillo { liveness = dead }.

% Gürteltier füttern
-spec feed_dillo(#dillo{}, number()) -> #dillo{}.
% feed_dillo(#dillo { liveness = Liveness, weight = Weight} = Dillo, Amount) ->
%   case Liveness of
%        alive -> Dillo#dillo { weight = Weight + Amount }; % #dillo { liveness = alive, weight = Weight + amount};
%        dead -> Dillo % #dillo { liveness = Liveness, weight = Weight}
%    end.
feed_dillo(#dillo { liveness = alive, weight = Weight} = Dillo, Amount) ->
    Dillo#dillo { weight = Weight + Amount};
feed_dillo(#dillo { liveness = dead } = Dillo, _Amount) ->
    Dillo.

% Papagei hat folgende Eigenschaften:
% - Satz
% - Gewicht
-record(parrot, { sentence :: string(), weight :: number()}).

% Begrüßungspapagei, 1kg
parrot1() -> #parrot { sentence = "Hello!", weight = 1}.
% Dicker Papagei, auf Abschied getrimmt
parrot2() -> #parrot { sentence = "Goodbye!", weight = 2}.

% Papagei überfahren
-spec run_over_parrot(#parrot{}) -> #parrot{}.
run_over_parrot(#parrot { sentence = _Sentence, weight = Weight}) ->
  #parrot { sentence = "", weight = Weight}.

% Tier (auf dem texanischen Highway) ist eins der folgenden:
% - Gürteltier -ODER-
% - Papagei
% Fallunterscheidung
% jeder einzelne Fall eigene Datendefinition:
% gemischte Daten
-type animal() :: #dillo{} | #parrot{}.

animal_is_alive(#dillo{liveness = alive}) -> true;
animal_is_alive(#parrot{}) -> true;
animal_is_alive(_) -> false.

% Tier überfahren
-spec run_over_animal(animal()) -> animal().
run_over_animal(#dillo{} = Dillo) -> 
    run_over_dillo(Dillo);
run_over_animal(#parrot{} = Parrot) ->
    run_over_parrot(Parrot).  


% Liste ist eins der folgenden:
% - die leere Liste: []
% - eine Cons-Liste aus erstem Element E und Rest-Liste R
%                                                 ^^^^^ Selbstbezug
%   [ E | R ]

% 1elementige Liste: 5 
list1() -> [5 | []].
% 2elementige Liste: 5 8
list2() -> [5 | [ 8 | []]].
list3() -> [5, 8, 3].
% 4elementige Liste 2 5 8 3
list4() -> [2 | list3() ].

% Elemente einer Liste aufsummieren
-spec list_sum(list(number())) -> number().
list_sum([]) -> 0;
list_sum([ First | Rest ]) ->
    First + list_sum(Rest).
 
-spec list_append(list(A), list(A)) -> list(A).
list_append([], List2) -> List2;
list_append([ First | Rest], List2) ->
    [First | list_append(Rest, List2)].

highway() -> [dillo1(), dillo2(), parrot1(), parrot2()].

% Alle Tiere überfahren
-spec run_over_animals(list(animal())) -> list(animal()).
run_over_animals([]) -> [];
run_over_animals([First|Rest]) ->
    [run_over_animal(First) | run_over_animals(Rest)].


% mit Hilfsfunktion, die testet, ob eine Zahl gerade ist oder nicht.
-spec is_even(integer()) -> boolean().
is_even(N) -> N rem 2 == 0.

% Funktion, welche aus einer Liste alle geraden Elemente extrahiert.
-spec extract_evens(list(integer)) -> list(integer()).
extract_evens([]) -> [];
extract_evens([First|Rest]) ->
    case is_even(First) of
        true ->  [First | extract_evens(Rest)];
        false -> extract_evens(Rest)
    end.

% mit Hilfsfunktion, die testet, ob eine Zahl gerade ist oder nicht.
-spec is_odd(integer()) -> boolean().
is_odd(N) -> N rem 2 == 1.

-spec extract_odds(list(integer())) -> list(integer()).
extract_odds([]) -> [];
extract_odds([First|Rest]) ->
    case is_odd(First) of
        true -> [First | extract_odds(Rest)];
        false -> extract_odds(Rest)
    end.

% Abstraktion:
% Ausgangssituation: 2 Stück Code, ähnlich bis auf Unterschiede4
% - kopieren
% - umbenennen
% - ersetzen die Unterschiede durch (abstrakte) Namen
% - die Namen zu Parametern machen
-spec extract(fun((A) -> boolean()), list(A)) -> list(A).
extract(_P, []) -> [];
extract(P, [First|Rest]) ->
    case P(First) of
        true -> [First | extract(P, Rest)];
        false -> extract(P, Rest)
    end.

