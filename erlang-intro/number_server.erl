-module(number_server).
-export([init/1, handle_cast/2, handle_call/3,
         start/0, number_inc/2, number_multiply/2]).

% Server mit Zustand
-behavior(gen_server).

-type state() :: number().

% Messages:
% will keine Antwort: "cast"
-record(multiply, { factor :: number() }).
-record(increment, { inc :: number() }).
-type cast_message() :: #increment{} | #multiply{}.

% will Antwort: "call"
-record(query, { pid :: pid() }).
-type call_message() :: #query{}.


start() ->
    gen_server:start(number_server, 7, []). % Module, Args, Options

% bekommt das, was an gen_server:start übergeben wird

% wird ausgeführt im Server-Prozeß   -> self()
-spec init(number()) -> {ok, state()}.
init(InitialN) -> {ok, InitialN}.

-spec number_inc(pid(), number()) -> any().
number_inc(Pid, Inc) ->
    % wichtig: ! funktioniert nicht direkt!
    gen_server:cast(Pid, #increment { inc = Inc }).

-spec number_multiply(pid(), number()) -> any().
number_multiply(Pid, Factor) ->
    gen_server:cast(Pid, #multiply { factor = Factor }).

-spec handle_cast(cast_message(), state()) -> {noreply, state()}.
handle_cast(#increment { inc = Inc}, N) -> 
    {noreply, N + Inc}; % wenn das hier komplizierter wird -> separate Funktion
handle_cast(#multiply { factor = Factor}, N) ->
    {noreply, N * Factor}.

-spec number_query(pid()) -> {ok, number()}.
number_query(Pid) ->
    gen_server:call(Pid, #query{}).

-spec handle_call(call_message(), pid(), state()) -> {reply, any(), state()}.
handle_call(#query { pid = _SenderPid}, _From, N) ->
    {reply,
     {ok, N}, % Antwort
     N}. % neuer Zustand