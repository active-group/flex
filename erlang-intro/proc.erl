-module(proc).
-export([format_server/0, start_format_server/0]).

format_server() ->
    receive
        Message -> io:format(Message)
        after 3000 ->
            io:format("timeout")
    end,
    format_server().

start_format_server() ->
    spawn(fun format_server/0).