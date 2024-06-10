-module(proc).
-export([format_server/0, start_format_server/p]).

format_server() ->
    receive
        Message -> io:format(Message),
                   format_server()
    end.

start_format_server() ->
    spawn(fun format_server/0).