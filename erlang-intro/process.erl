-module(process).
-export([counter_code/1,
         counter_inc/1, counter_inc/2,
         counter_get/1]).

% Eine Nachricht an counter_code ist eins der folgenden:
% - inc - ODER -
% - inc-by-Record

-record(inc_by, {increment :: integer() }).
-record(get, {requester :: pid()}).

-type message() :: inc | #inc_by{} | #get{}.

% Zähler-Prozess
counter_code(N) ->
    receive
        inc ->
            io:format("counter: ~w~n", [N]),
            counter_code(N+1);
        #inc_by{ increment = Inc } ->
            io:format("counter: ~w~n", [N]),
            counter_code(N+Inc);
        #get{requester = Req } ->
            Req ! N,
            counter_code(N)
    end.

counter_inc(Pid) -> Pid ! inc.

counter_inc(Pid, Inc) ->
    Pid ! #inc_by{increment = Inc}.

counter_get(Pid) ->
    Pid ! #get{requester = self() },
    receive
        N -> N
    end.

% self(): Pid des laufenden Prozesses