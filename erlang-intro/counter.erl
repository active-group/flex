-module(counter).
-export([init/1]).

-behavior(gen_server).

-record(inc_by, {increment :: integer() }).
-record(get, {requester :: pid()}).

-type message() :: inc | #inc_by{} | #get{}.

% State of our counter server
-type state() :: integer().

init(InitialState) ->
    {ok, InitialState}.

