-module(inc_server).
-export([init/1,
         handle_cast/2,
         handle_call/3]).

% "Wir implementieren ein Interface"
-behavior(gen_server).


% Zählerstand inkrementieren -> cast
-record(inc, { increment :: number()}).

% Zählerstand liefern -> call
-record(get, { }).

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