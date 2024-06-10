-module(proc).

format_server() ->
    receive
        Message -> io:format(Message),
                   format_server()
    end.