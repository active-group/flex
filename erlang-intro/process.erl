-module(process).
-export([counter_code/1, counter_inc/1]).

% Eine Nachricht an counter_code ist eins der folgenden:
% - inc - ODER -
% - inc-by-Record

-record(inc_by, {increment :: integer() }).

-type message() :: inc | #inc_by{}.

% Zähler-Prozess
counter_code(N) ->
    receive
        inc ->
            io:format("counter: ~w~n", [N]),
            counter_code(N+1);
        #inc_by{ increment = Inc } ->
            io:format("counter: ~w~n", [N]),
            counter_code(N+Inc)
    end.

counter_inc(Pid) -> Pid ! inc.

counter_inc(Pid, Inc) ->
    Pid ! #inc_by{increment = Inc}.