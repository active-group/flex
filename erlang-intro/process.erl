-module(process).
-export([process_code/0, 
         counter_code/1, counter/1, counter_inc/1]).

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
        {get, ClientPid} ->
            ClientPid ! N,
            counter_code(N)
    end.

counter(N) ->
    spawn(process, counter_code, [N]).

counter_inc(Pid) ->
    Pid ! inc.

counter_get(ServerPid) ->
    ServerPid ! {get, self()},
    receive N -> N end. 