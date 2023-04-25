-module(counter).
-export([init/1, handle_cast/2]).

-behavior(gen_server).

-record(inc_by, {increment :: integer() }).
-record(get, {requester :: pid()}).

-type message() :: inc | #inc_by{} | #get{}.

% State of our counter server
-type state() :: integer().

-spec init(state()) -> {ok, state()}.
init(InitialState) ->
    {ok, InitialState}.

-spec handle_cast(message(), state()) -> {noreply, state()}.
handle_cast(inc, N) -> {noreply, N+1};
handle_cast(#inc_by{ increment = Inc }, N) ->
     {noreply, N+Inc}.