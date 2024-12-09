-module(proc).
-export([number_start/1]).
% Service, der eine Zahl verwaltet

number_start(InitialN) ->
    spawn(fun () -> number_loop(InitialN) end).

number_loop(N) ->
    receive
        {query, SenderPid} ->
            SenderPid ! N,
            number_loop(N);
        Inc -> 
            io:format("old N: ~w~n", [N]),
            number_loop(N + Inc)
    end.