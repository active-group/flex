-module(inc_server).
-export([init/1, handle_cast/2]).

% "Wir implementieren ein Interface"
-behavior(gen_server).


% Zählerstand inkrementieren -> cast
-record(inc, { increment :: number()}).

% Zählerstand liefern -> call
-record(get, { pid :: pid()}).

% Callback
init(Init) ->
    {ok, Init}.

% cast: asynchrone Nachricht an den Server, ohne Antwort
% call: Nachricht mit Antwort

handle_cast(#inc{increment = Inc}, N) ->
    {noreply, N + Inc}.

handle_call()