-module(proc).
-export([format_server/0, start_format_server/0,
         inc_server/1,
         inc_server_get/1]).

format_server() ->
    receive
        Message -> io:format(Message)
        after 3000 ->
            io:format("timeout")
    end,
    format_server().

start_format_server() ->
    spawn(fun format_server/0).

-record(inc, {increment :: number()}).
-record(get, { client_pid :: pid() }).

-type inc_server_message() :: #inc{} | #get{}.

inc_server(N) ->
    io:format("N = ~w~n", [N]),
    receive
        #get{ client_pid = ClientPid} -> 
            ClientPid ! N,
            inc_server(N);
        #inc{ increment = Inc } -> inc_server(N+Inc)
    end.

% RPC
inc_server_get(ServerPid) ->
    ServerPid ! #get { client_pid = self },
    receive
        N -> N
    end.