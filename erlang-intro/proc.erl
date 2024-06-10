-module(proc).
-export([format_server/0, start_format_server/0]).

format_server() ->
    receive
        Message -> io:format(Message),
                   format_server()
        after 10000 ->
            io:format("timeout")
    end.

start_format_server() ->
    spawn(fun format_server/0).