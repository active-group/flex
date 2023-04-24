-module(intro).
-export([double/1, is_cute/1, % /1 Anzahl der Parameter
         water_state/1, safe_divide/2, slope/2,
         t1/0, t2/0,
         minutes_since_midnight/1,
         d1/0, d2/0,
         run_over_dillo/1, feed_dillo/1,
         p1/0, p2/0, run_over_animal/1,
         list0/0, list1/0, list2/0, list3/0, list4/0,
         list_sum/1, list_nth/2,
         highway/0, run_over_animals/1]).
% . fertig
% ; "oder"
% , "und"

-spec double(number()) -> number().
double(X) -> X * 2.

% Atom: "konstante Zeichenkette" / Name


% Haustier ist eins der folgenden:
% - Hund - ODER -
% - Katze - ODER -
% - Schlange

% Ist ein Haustier niedlich?
-spec is_cute(dog | cat | snake) -> boolean().
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
-spec water_state(number()) -> liquid | solid | gas.
%water_state(Temperature) ->
%    if
%        Temperature < 0 -> solid;
%        Temperature > 100 -> gas;
%        true -> liquid
%    end.
water_state(Temperature) when Temperature < 0 -> solid;
water_state(Temperature) when Temperature > 100 -> gas;
water_state(_Temperature) -> liquid.

% Tupel: {1, true, "Mike"}

-spec safe_divide(number(), number()) -> {error, divide_by_zero} | {ok, number()}.
safe_divide(X, Y) ->
    if 
        Y == 0 -> {error, divide_by_zero};
        true -> {ok, X / Y}
    end.

% Steigung eine Geraden berechnen
-spec slope({number(), number()}, {number(), number()}) -> number() | vertical.
slope({X1, Y1}, {X2, Y2}) ->
    case safe_divide(Y2 - Y1, X2 - X1) of
        {error, divide_by_zero} -> vertical;
        {ok, S} -> S
    end.

% Zusammengesetzte Daten
% Records

% Eine Uhrzeit besteht aus:
% - Stunde - UND -
% - Minute
-record(time, {hour :: 0..23, second = 0 :: 0..59, minute :: 0..59}).

% 5 nach 12
t1() -> #time{ hour = 12, minute = 5}.
% 14:27 Uhr
t2() -> #time{ hour = 14, minute = 27}.

% Minuten seit Mitternacht
-spec minutes_since_midnight(#time{}) -> integer().
% minutes_since_midnight(Time) ->
%    Time#time.hour * 60 + Time#time.minute.
minutes_since_midnight(#time{ hour = H, minute = M}) ->
    H * 60 + M.

% Tiere auf dem texanischen Highway

% Ein Gürteltier hat folgende Eigenschaften:
% - tot oder lebendig - UND -
% - Gewicht
-record(dillo, { liveness :: dead | alive, weight :: number()}).

% Gürteltier, lebendig, 10kg
d1() -> #dillo{liveness = alive, weight = 10}.
% totes Gürteltier, 8kg
d2() -> #dillo{liveness = dead, weight = 8}.
% Gürteltier überfahren
-spec run_over_dillo(#dillo{}) -> #dillo{}.
% run_over_dillo(#dillo{ weight = W}) ->
%    #dillo{ liveness = dead, weight = W}.

% "functional update"
run_over_dillo(D) ->
    D#dillo{ liveness = dead }. % D kopieren bis auf Feld "liveness"

% Gürteltier füttern
% lebendige Gürteltiere nehmen zu, tote Gürteltiere nicht
%

-spec should_feed(#dillo{}) -> boolean().
should_feed(#dillo{liveness = L}) ->
%    if
%        L == alive -> true;
%        L == dead -> false
%    end.
    case L of
        alive -> true;
        dead -> false
    end.

-spec feed_dillo(#dillo{}) -> #dillo{}.
% feed_dillo(#dillo{liveness = L, weight = W} = D) ->
%     case should_feed(D) of
%         true -> #dillo{ liveness = L, weight = W + 1};
%         false -> D
%     end.

feed_dillo(D) ->
    #dillo{weight = W} = D,
    case should_feed(D) of
        true -> D#dillo{weight = W + 1}; % #dillo{ liveness = L, weight = W + 1};
        false -> D
    end.

% Ein Papagei hat folgende Eigenschaften:
% - ein Satz - UND -
% - ein Gewicht
-record(parrot, { sentence :: string(), weight :: number() }).

p1() -> #parrot{sentence = "Hallo!", weight = 1}.
p2() -> #parrot{sentence = "Tschüss!", weight = 2}.

-spec run_over_parrot(#parrot{}) -> #parrot{}.
run_over_parrot(#parrot{ sentence = S, weight = W}) ->
    #parrot{ sentence = "", weight = W}.

% Ein Tier ist eins der folgenden:
% - ein Gürteltier - ODER -
% - ein Papagei
-type animal() :: #dillo{} | #parrot{} | any().

% Ein Tier überfahren
-spec run_over_animal(animal()) -> animal().
run_over_animal(#dillo{} = D) -> run_over_dillo(D);
run_over_animal(#parrot{} = P) -> run_over_parrot(P);
run_over_animal(A) -> A.

% Eine Liste ist eins der folgenden:
% - die leere Liste  [] - ODER - 
% - eine Cons-Liste aus erstem Element und Rest-Liste   [F | R]
%                                   Selbstbezug ^^^^^
list0() -> [].
% 1elementige Liste: 5
list1() -> [5 | []].
% 2elementige Liste: 5 8
list2() -> [5 | [8 | []]].
% 3elementige Liste
list3() -> [5 | [8 | [7 | []]]]. % [5, 8, 7].
% 4elementige Liste: 2 5 8 7
list4() -> [2 | list3()].

% Summe der Listenelemente berechnen
-spec list_sum(list(number())) -> number().
list_sum([]) -> 0;
list_sum([First | Rest]) -> 
    First + list_sum(Rest). % Kontext: First + []  // "Loch"

% ntes Element einer Liste extrahieren
-spec list_nth(list(A), non_neg_integer()) -> {ok, A} | {error, list_too_short}. 
list_nth([], _)            -> {error, list_too_short};
% list_nth([], 0)            -> {error, list_too_short};
% list_nth([], N) when N > 0 -> {error, list_too_short};
list_nth([First | _Rest], 0) -> {ok, First};
list_nth([_First | Rest], N) when N > 0 ->
    list_nth(Rest, N-1). % kein Kontext, tail call, endrekursiver Aufruf, verbraucht keinen Stack

highway() -> [d1(), d2(), p1(), p2()].

% Aufgabe: Eine Liste von Tieren überfahren.
-spec run_over_animals(list(animal())) -> list(animal()).
run_over_animals([]) -> [];
run_over_animals([First|Rest]) -> 
    [run_over_animal(First) | run_over_animals(Rest)].

% Strings: Listen von Zahlen (Unicode scalar values)
% Binary: Array aus Bytes
% <<5,6,7>>: Array aus den Bytes 5,6,7
% <<"ABC">>: Array aus den Bytes 65, 66, 67 (UTF-8)

% Alle Elemente einer Liste um 1 erhöhen
-spec inc_list(list(number())) -> list(number()).
inc_list([]) -> [];
inc_list([First|Rest]) ->
    [inc(First) | inc_list(Rest)].

inc(X) -> X+1.

list_map(F, []) -> [];
list_map(F, [First|Rest]) ->
    [F(First) | list_map(F, Rest)].

run_over_animals2(Animals) ->
    list_map(fun run_over_animal/1, Animals).
inc_list2(List) ->
    list_map(fun (X) -> X+1 end, List).
