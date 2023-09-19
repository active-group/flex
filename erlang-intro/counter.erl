-module(counter).
-export([init/1, handle_call/3, handle_cast/2,
         counter_get/1, counter_inc/1, counter_inc/2, start/1]).

-behavior(gen_server).

-type state() :: number().
-type cast_message() :: inc | {inc, number()}.
-type call_message() :: get.

start(N) ->
    gen_server:start(counter, 
                    N, % -> init
                    []).

-spec init(number()) -> {ok, state()}.
init(N) -> {ok, N}.

counter_get(Pid) ->
    gen_server:call(Pid, get).

counter_inc(Pid) ->
    gen_server:cast(Pid, inc).
counter_inc(Pid, Inc) ->
    gen_server:cast(Pid, {inc, Inc}).

-spec handle_cast(cast_message(), state()) -> {noreply, state()}.
handle_cast(inc, State) ->
    {noreply, State + 1};
handle_cast({inc, Inc}, State) ->
    {noreply, State + Inc}.

-spec handle_call(call_message(), pid(), state()) -> {reply, number(), state()}.
handle_call(get, _From, State) ->
    {reply, 
     State, % Antwort
     State}. % neue Zustand
