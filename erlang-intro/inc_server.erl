-module(inc_server).
-export([init/1,
         handle_cast/2,
         handle_call/3,
         start/1,
         inc_by/2, inc_get/1]).

% "Wir implementieren ein Interface"
-behavior(gen_server).


% Zählerstand inkrementieren -> cast
-record(inc, { increment :: number()}).

% Zählerstand liefern -> call
-record(get, { }).

-spec start(number()) -> {ok, pid()}.
start(Init) ->
    gen_server:start({local, inc_service}, inc_server, Init, [{debug, [trace]}]).

% Callback
init(Init) ->
    {ok, Init}.

% cast: asynchrone Nachricht an den Server, ohne Antwort
% call: Nachricht mit Antwort

handle_cast(#inc{increment = Inc}, N) ->
    {noreply, N + Inc}.

handle_call(#get {}, _From, N) ->
    {reply, 
     N, % reply 
     N}. % new state

inc_by(Pid, Inc) ->
    gen_server:cast(Pid, #inc{increment = Inc}).

inc_get(Pid) ->
    gen_server:call(Pid, #get{}).