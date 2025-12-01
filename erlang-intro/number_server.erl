-module(number_server).
-export([init/1, handle_cast/2, handle_call/3]).

% Server mit Zustand
-behavior(gen_server).

-type state() :: number().

% Messages:
% will Antwort: "call"
-record(query, { pid :: pid() }).

% will keine Antwort: "cast"
-record(multiply, { factor :: number() }).
-record(increment, { inc :: number() }).

init(InitialN) -> {ok, InitialN}.

handle_cast(#increment { inc = Inc}, N) -> 
    {noreply, N + Inc};
handle_cast(#multiply { factor = Factor}, N) ->
    {noreply, N * Factor}.

handle_call(#query { pid = SenderPid}, From, N) ->
    {reply,
     N, % Antwort
     N}. % neuer Zustand