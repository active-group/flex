-module(counter).

-behavior(gen_server).

-type state() :: number().

-spec init(number()) -> {ok, state()}.
init(N) -> {ok, N}.

