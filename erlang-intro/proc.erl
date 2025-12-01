-module(proc).
-export([number_server/1, number_inc/2,
         number_query/1]).

number_server(InitialN) ->
    spawn(fun () -> number_loop(InitialN) end).

% Zahl erhöhen
-spec number_inc(pid(), number()) -> any().
number_inc(Pid, Inc) ->
    Pid ! Inc.

% Zahl mit Faktor multiplizieren

% Prozeß, der eine Zahl (Zustand) verwaltet
% Operationen:
% - hochzählen
% - abfragen

-record(query, { pid :: pid() }).

-spec number_query(pid()) -> number().
number_query(Pid) ->
    Pid ! #query { pid = self() }, % self(): eigene Pid
    receive N -> N end.

% Brauchen Funktion mit Zustand als Parameter
number_loop(N) ->
    receive
        #query { pid = SenderPid } -> % brauche Pid des Absenders
            SenderPid ! N,
            number_loop(N);
        Inc -> 
            io:format("N: ~p, Inc: ~p\n", [N, Inc]),
            number_loop(N + Inc)
    end.
