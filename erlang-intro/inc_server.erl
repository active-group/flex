-module(inc_server).
-export([init/1]).

% "Wir implementieren ein Interface"
-behavior(gen_server).

% Callback
init(Init) ->
    {ok, Init}.

