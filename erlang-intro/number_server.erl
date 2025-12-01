-module(number_server).
-export([init/1]).

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
