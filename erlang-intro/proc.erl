-module(proc).
-export([number_start/1,
         number_add/2,
         number_query/1]).
% Service, der eine Zahl verwaltet

number_start(InitialN) ->
    spawn(fun () -> number_loop(InitialN) end).

number_query(Pid) ->
    Pid ! {query, self()},
    receive
        N -> {ok, N}
    end.

number_add(Pid, Inc) ->
    Pid ! Inc.

number_loop(N) ->
    receive
        {query, SenderPid} ->
            SenderPid ! N,
            number_loop(N);
        % zusätzlich:
        % - Multiplikation
        % - Subtraktion
        Inc -> 
            io:format("old N: ~w~n", [N]),
            number_loop(N + Inc)
    end.