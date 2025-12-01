-module(number_server).
-export([init/1]).

% Server mit Zustand
-behavior(gen_server).

-type state() :: number().

init(InitialN) -> {ok, InitialN}.
