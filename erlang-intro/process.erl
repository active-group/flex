-module(process).

% Zähler-Prozess
counter_code(N) ->
    receive
        inc ->
            io:format("counter: ~w~n", [N]),
            counter_code(N+1)
    end.