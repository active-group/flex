-module(counter).
-export([init/1,
         counter_get/1]).

-behavior(gen_server).

-type state() :: number().
-type message() :: inc | {inc, number()} | {get, pid()}.

-spec init(number()) -> {ok, state()}.
init(N) -> {ok, N}.

counter_get(Pid) ->
    gen_server:call(Pid, {get, self()}).

handle_call({get, _Pid}, _From, State) ->
    {reply, 
     State, % Antwort
     State}. % neue Zustand