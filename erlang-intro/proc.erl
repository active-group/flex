-module(proc).
-export([format_server/0, start_format_server/0,
         inc_server/1]).

format_server() ->
    receive
        Message -> io:format(Message)
        after 3000 ->
            io:format("timeout")
    end,
    format_server().

start_format_server() ->
    spawn(fun format_server/0).

inc_server(N) ->
    io:format("N = ~w~n", [N]),
    receive
        {get, Pid} -> Pid ! N;
        Inc -> inc_server(N+Inc)
    end.