-module(intro).
-export([double/1, double/2,
         is_cute/1, water_state/1,
         safe_divide/2,
         dogs_per_legs/1,
         t1/0, t2/0, t_error/0,
         minutes_since_midnight/1,
         d1/0, d2/0, 
         run_over_dillo/1]).

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
p1() -> #parrot { sentence = "Welcome!", 1}.
p2() -> #parrot { sentence = "Tschüss!", 2}.

% Datenstrukturen sind in Erlang "immutable"
-spec run_over_dillo(#dillo{}) -> #dillo{}.
% run_over_dillo(#dillo{ weight = Weight}) ->
%    #dillo { liveness = dead, weight = Weight}.
run_over_dillo(Dillo) ->
    Dillo#dillo { liveness = dead }. % functional update