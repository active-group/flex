-module(intro).
-export([double/1, is_cute/1,
         water_state/1,
         safe_divide/2,
         slope/2,
         t1/0, minutes_since_midnight/1,
         dillo1/0, dillo2/0,
         run_over_dillo/1,
         feed_dillo/2]).

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

% Tier überfahren
-spec run_over_animal(animal()) -> animal().
run_over_animal(#dillo{} = Dillo) -> run_over_dillo(Dillo);
run_over_animal(#parrot() = Parrot) -> run_over_parrot(Parrot).  