-module(process).
-export([counter_code/1, counter_inc/1]).

% Zähler-Prozess
counter_code(N) ->
    receive
        inc ->
            io:format("counter: ~w~n", [N]),
            counter_code(N+1)
    end.

counter_inc(Pid) -> Pid ! inc.