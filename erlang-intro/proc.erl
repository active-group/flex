-module(proc).

% Service, der eine Zahl verwaltet

number_loop(N) ->
    receive
        Inc -> 
            io:format("old N: ~w~n", [N]),
            number_loop(N + Inc)
    end.