-module(inc_server).
-export([init/1]).

% "Wir implementieren ein Interface"
-behavior(gen_server).

% Zählerstand inkrementieren
-record(inc, { increment :: number()}).

% Zählerstand liefern
-record(get, { pid :: pid()}).

% Callback
init(Init) ->
    {ok, Init}.

% cast: asynchrone Nachricht an den Server, ohne Antwort
% call: Nachricht mit Antwort