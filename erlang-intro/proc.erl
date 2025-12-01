-module(proc).
-export([number_server/1]).

number_server(InitialN) ->
    spawn(fun () -> number_loop(InitialN) end).

% Zahl erhöhen
-spec number_inc(pid(), number()) -> any().
number_inc(Pid, Inc) ->
    Pid ! Inc.

% Prozeß, der eine Zahl (Zustand) verwaltet
% Operationen:
% - hochzählen
% - abfragen

% Brauchen Funktion mit Zustand als Parameter
number_loop(N) ->
    receive
        Inc -> 
            io:format("N: ~p, Inc: ~p\n", [N, Inc]),
            number_loop(N + Inc)
    end.
