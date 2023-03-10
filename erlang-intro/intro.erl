-module(intro).
-export([double/1, double/2,
         is_cute/1, water_state/1,
         safe_divide/2,
         dogs_per_legs/1,
         t1/0, t2/0, t_error/0,
         minutes_since_midnight/1,
         d1/0, d2/0, 
         run_over_dillo/1,
         p1/0, p2/0,
         animal_weight/1,
         run_over_animal/1,
         list_sum/1,
         highway/0, 
         animal_weights/1,
         list_map/2,
         rev/1, rev/2,
         compose/2,
         process_demo/0,
         inc_process/1, inc_loop/1,
         inc_by/2, inc_get/1]).

% . fertig
% ; "oder"
% , "und"

% Variablen: fangen mit Großbuchstaben an
% Funktionen: fangen mit Kleinbuchstaben an
% Stelligkeit gehört zum Funktionsnamen dazu
-spec double(number()) -> number().
double(X) -> X * 2.

double(X, Y) -> X * Y * 2.

% Atome: fangen auch mit Kleinbuchstaben an
% "Namen"

% Ist ein Haustier niedlich?
% Ein Haustier ist eins der folgenden:
% - Hund
% - Katze
% - Schlange
-type pet() :: dog | cat | snake. 
-spec is_cute(pet()) -> boolean().
% is_cute(Pet) ->
%    case Pet of
%        dog -> true;
%        cat -> true;
%        snake -> false
%    end.
% 
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

% Tupel:
% {1,true,"Mike"}

-spec safe_divide(number(), number()) -> {error, divide_by_zero} | {ok, number()}.
safe_divide(X, Y) ->
    if
        Y == 0 -> {error, divide_by_zero};
        true -> {ok, X/Y} % Erlang-Konvention
    end.

% Hunde pro Beine
dogs_per_legs(Legs) ->
    % {ok, Dogs} = safe_divide(Legs, 4),
    case safe_divide(Legs, 4) of
        {error, What} -> {error, this_cant_happen, What};
        {ok, Dogs} -> Dogs
    end.

% Uhrzeit besteht aus:
% - Stunde
% - Minute
-record(time, {hour :: 0..23, minute :: 0..59}).

% Uhrzeit 11:34
t1() -> #time{ hour = 11, minute = 34 }.
% 14:27
t2() -> #time{ hour = 14, minute = 27}.
t_error() -> #time { hour = 14}.

% Minuten seit Mitternacht
-spec minutes_since_midnight(#time{}) -> non_neg_integer().
% minutes_since_midnight(Time) ->
%    Time#time.hour * 60 +
%    Time#time.minute.
minutes_since_midnight(#time { hour = H, minute = M}) ->
    H * 60 + M.

% Ein Tier auf dem texanischen Highway
% ist eins der folgenden:
% - Gürteltier - ODER -
% - Parrot
% Fallunterscheidung

% Ein Gürteltier hat folgende Eigenschaften:
% - tot oder lebendig - UND -
% - Gewicht
% zusammengesetzte Daten
-record(dillo, { liveness :: dead | alive, weight :: number()}).

% lebendiges Gürteltier, 10kg
d1() -> #dillo { liveness = alive, weight = 10}.
% totes Gürteltier, 8kg
d2() -> #dillo { liveness = dead, weight = 8}.

% Ein Papagei hat folgende Eigenschaften:
% - Satz
% - Gewicht
-record(parrot, { sentence :: string(), weight :: number() }).

% Begrüßungspapagei
p1() -> #parrot { sentence = "Welcome!", weight = 1}.
p2() -> #parrot { sentence = "Tschüss!", weight = 2}.

% Datenstrukturen sind in Erlang "immutable"
-spec run_over_dillo(#dillo{}) -> #dillo{}.
% run_over_dillo(#dillo{ weight = Weight}) ->
%    #dillo { liveness = dead, weight = Weight}.
run_over_dillo(Dillo) ->
    Dillo#dillo { liveness = dead }. % functional update

-type animal() :: #dillo{} | #parrot{}.

-spec animal_weight(animal()) -> number().
animal_weight(#dillo{ weight = Weight}) -> Weight;
animal_weight(#parrot{ weight = Weight}) -> Weight.

-spec run_over_animal(animal()) -> animal().
run_over_animal(#dillo{ weight = Weight }) ->
    #dillo { liveness = dead, weight = Weight};
run_over_animal(Parrot = #parrot{}) ->
    Parrot#parrot { sentence = "" }.

% Eine Liste ist eins der folgenden:
% - die leere Liste - ODER -
% - eine Cons-Liste aus erstem Element und Rest-Liste
%                                               ^^^^^

% In Erlang:
% leere Liste: []
% Cons-Liste: [First | Rest]
% 
% syntaktischer Zucker: [1,2,3,4,5]

% 1elementige Liste: 5
list1() -> [5 | []].
% 2elementige Liste: 7 5
list2() -> [7 | [5 | []]].
% gleiche Liste:
list2a() -> [7, 5].
% 3elementige Liste: 2 7 5
list3() -> [2 | list2a()].

% für jeden Fall einer Fallunterscheidung 1 Gleichung
-spec list_sum(list(number())) -> number().
% -spec list_sum([number()]) -> number().
list_sum([]) -> 0;
list_sum([First | Rest]) -> 
    First  + list_sum(Rest). % rekursiven Aufruf auf dem Selbstbezug

-spec highway() -> list(animal()).
highway() -> [d1(), d2(), p1(), p2()].

% Gewichte der Tiere feststellen
-spec animal_weights(list(animal())) -> list(number()).
animal_weights([]) -> [];
animal_weights([First | Rest]) -> 
    [animal_weight(First) | animal_weights(Rest)].

% Abstraktion über animal_weights & run_over_animals
-spec list_map(fun((A) -> B), list(A)) -> list(B).
list_map(_F, []) -> [];
list_map(F, [First | Rest]) -> 
    [F(First) | list_map(F, Rest)].

-spec run_over_animals(list(animal())) -> list(animal()).
run_over_animals(Animals) ->
    list_map(fun intro:run_over_animal/1, Animals).

% Laufzeit für Liste der Länge n:
% 1 + 2 + 3 +... + (n-2) + (n-1) + n
% = (n * (n+1)) / 2 = 1/2 n^2 + ...  = O(n^2)

% Liste umdrehen
-spec rev(list(A)) -> list(A).
rev([]) -> [];
rev([First | Rest]) -> 
    add_element(rev(Rest), First).

-spec compose(fun((B) -> C), fun((A) -> B)) -> fun((A) -> C).
compose(F, G) -> fun (A) -> F(G(A)) end.
 
% Element an Liste hinten anhängen
-spec add_element(list(A), A) -> list(A).
add_element([], A) -> [A];
add_element([First | Rest], A) ->
    % erst rekursiver Aufruf, dann First vorne dran consen
    [First | add_element(Rest, A)]. % Kontext

% mit Akkumulator / Zwischenergebnis
% enthält die bisher gesehenen Element, umgedreht
rev([], Acc) -> Acc;
rev([First | Rest], Acc) ->
    % tail call, endrekursiver Aufruf
    rev(Rest, [First | Acc]). % kein Kontext => keinen Platz auf dem Stack

% Binary: <<"Mike">>

% Prozesse / (heute: "Threads")
% 
% spawn startet einen Prozess
% <0.281.0>: Beispiel für Process Id
% 

process_loop() ->
    receive % "wie case"
        shutdown -> io:format("Goodbye!");
        Message -> io:format("Received message: ~w~n", [Message]),
                   process_loop()
    end.

process_demo() ->
    spawn(fun process_loop/0).
%    spawn(fun () ->
%        receive % "wie case"
%            Message -> io:format("Received message: ~w~n", [Message])
%        end
%    end).
% 
% Prozess implementieren:
% 1. Datentyp für die Messages - i.d.R. eine Fallunterscheidung aus Records
% 2. endrekursive Funktion schreiben, Zustand ist Parameter
% 3. Rumpf besteht aus receive ... end, 1 Zweig pro Message-Fall
%    ggf. endrekursiver Aufruf
% 4. wenn Antworf erwünscht, Pid in Message einpacken, Antwort zurückschicken
% 5. Convenience-Funktionen machen, für jede Art von Message eine
% 
% Zählerstand inkrementieren
-record(inc, { increment :: number()}).

% Zählerstand liefern
-record(get, { pid :: pid()}).

% Inkrementier-Prozess
inc_loop(N) ->
    receive % wie case ... of
        % i.d.R.: irgendwas paßt immer
        #inc{increment = Inc} ->
               NewN = N + Inc,
               io:format("New N: ~w~n", [NewN]),
               inc_loop(NewN);
        #get{pid = Pid} ->
            Pid ! N,
            inc_loop(N)
    end,
    inc_loop(N).

inc_by(Pid, Inc) ->
    Pid ! #inc{increment = Inc}.

inc_get(Pid) ->
    Pid ! #get{pid = self()}, % Pid von "diesem" Prozess
    receive
        Value -> Value % kein Semikolon
    after 5000 -> timeout % milliseconds
    end.

inc_supervisor(Init) ->
    process_flag(trap_exit, true),
    % Pid = spawn(?MODULE, inc_loop, [Init]),
    % race
    % link(Pid), % "Dein Schicksal ist mein Schicksal"
    % atomar spawn + link
    % Pid = spawn_link(?MODULE, inc_loop, [Init]),
    Pid = spawn(?MODULE, inc_loop, [Init]),
    % schickt auch eine Nachricht, wenn Pid schon gestorben ist.
    erlang:monitor(process, Pid),
    register(inc_service, Pid),
    receive
        {'EXIT', _Pid, _Reason} -> % Nachricht von link
            inc_supervisor(Init);
        {'DOWN', _, process , _Pid, _Reason} ->
            inc_supervisor(Init)
        % Msg when erlang:is_tuple(Msg) ->
    end.


inc_process(Init) ->
    % muß exportiert sein
    % spawn(intro, inc_loop, [Init]).
    % synonym dazu:
    % wenn ein gelinkter Prozeß stirbt, bekommen wir eine Nachricht
    % Self = self(), % Pid der Shell
    spawn(fun () ->
            inc_supervisor(Init) % terminiert nicht (mehr)
            % Self ! Pid
          end).
    % receive Pid -> Pid end.
    

% bitte inc_process erweitern um:
% - multiplizieren
% - subtrahieren
% - reset auf 0

% Frequency server
% - Gibt eine Liste von zu vergebenden Frequenzen
% - man kann sich eine freie Frequenz geben lassen
% - man kann eine Frequenz zurückgeben
% 

is_process_registered(Name) ->
    case erlang:whereis(Name) of
        undefined -> false;
        _ -> true
    end.