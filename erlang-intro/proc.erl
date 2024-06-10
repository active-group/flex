-module(proc).
-export([format_server/0]).

format_server() ->
    receive
        Message -> io:format(Message),
                   format_server()
    end.