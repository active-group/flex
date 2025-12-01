-module(proc).
-export([number_server/1, number_inc/2, number_multiply/2,
         number_query/1,
         start_die_process/0, die_process/0]).

number_server(InitialN) ->
    spawn(fun () -> number_loop(InitialN) end).

% Zahl erhöhen
%-spec number_inc(pid(), number()) -> any().
%number_inc(Pid, Inc) ->
%    Pid ! Inc.

% Zahl mit Faktor multiplizieren

% Prozeß, der eine Zahl (Zustand) verwaltet
% Operationen:
% - hochzählen
% - abfragen

-record(query, { pid :: pid() }).
-record(multiply, { factor :: number() }).
-record(increment, { inc :: number() }).

-spec number_query(pid()) -> number().
number_query(Pid) ->
    Pid ! #query { pid = self() }, % self(): eigene Pid
    receive N -> N end.

-spec number_multiply(pid(), number()) -> any().
number_multiply(Pid, Factor) ->
    Pid ! #multiply { factor = Factor }.

-spec number_inc(pid(), number()) -> any().
number_inc(Pid, Inc) ->
    Pid ! #increment { inc = Inc}.

% Brauchen Funktion mit Zustand als Parameter
-spec number_loop(number()) -> no_return().
number_loop(N) ->
    receive
        #query { pid = SenderPid } -> % brauche Pid des Absenders
            SenderPid ! N,
            number_loop(N);
        #multiply { factor = Factor } ->
            number_loop(N * Factor);
        #increment { inc = Inc} ->
            number_loop(N + Inc)
%        Inc -> 
%            io:format("N: ~p, Inc: ~p\n", [N, Inc]),
%            number_loop(N + Inc)
    end.

die_process() ->
    receive
        Msg -> io:format("Message: ~p\n", [1/Msg]),
        die_process()
    end.

start_die_process() ->
    Pid = spawn(proc, die_process, []),
    %           ^^^^ Modulname
    %                 ^^^ Funktionsname
    %                               ^^^ Argumente
    link(Pid), % "wenn Du stirbst, sterbe ich auch und umgekehrt"
    Pid.