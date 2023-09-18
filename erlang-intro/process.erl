-module(process).
-export([process_code/0]).

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
            counter_code(N+1)
    end.