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
-record(get, { client_pid :: pid() }). % RPC

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

% Frequency-Server
% verwaltet eine Liste von freien Funkfrequenzen
% Zustand ^^^ -> Parameter
% Operationen -> Message (mit Antwort? / RPC?)
% - gib mir ne Frequenz <- RPC
% - ich geb Dir ne Frequenz zurück -> "fire-and-forget"

-type frequency() :: number().
-type frequency_state() :: list(frequency()).

-record(get_frequency, { client_pid :: pid() }).
-record(return_frequency, { frequency :: frequency() }).

-type frequency_message() :: #get_frequency{} | #return_frequency{}.

% Funktion, die nimmt Zustand als Argument
% ... receive mit einem Zweig pro Message
% dran denken: muß explizit die Funktion aufrufen, damit's weitergeht

-spec frequency_server(frequency_state()) -> none().

frequency_server([]) ->
    receive
        #get_frequency{ client_pid = ClientPid} ->
            ClientPid ! no_frequency_left,
            frequency_server([]);
        #return_frequency { frequency = Frequency } -> 
            frequency_server([Frequency])
    end;
frequency_server([First | Rest]) ->
    receive
        #get_frequency{ client_pid = ClientPid} -> todo;
        #return_frequency { frequency = Frequency } -> 
            todo
    end.
