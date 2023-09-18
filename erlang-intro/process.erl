-module(process).
-export([process_code/0, 
         counter_code/1, counter/1, counter_inc/1, counter_inc/2, counter_get/1]).

process_code() ->
    receive % Syntax ist wie case
        "Mike" ->
            io:format("Mike ist da.~n"),
            process_code();
        "Sperber" -> io:format("Sperber ist doof.~n")
    end.

counter_code(N) ->
    io:format("counter: ~w~n", [N]),
    receive
        inc -> 
            counter_code(N+1);
        {inc, Inc} ->
            counter_code(N+Inc);
        {get, ClientPid} ->
            ClientPid ! N,
            counter_code(N)
    end.

counter(N) ->
    spawn(process, counter_code, [N]).

counter_inc(Pid) ->
    Pid ! inc.

counter_inc(Pid, Inc) ->
    Pid ! {inc, Inc}.

counter_get(ServerPid) ->
    ServerPid ! {get, self()},
    receive N -> N end. 