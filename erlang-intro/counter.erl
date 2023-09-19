-module(counter).
-export([init/1, handle_call/3, handle_cast/2,
         counter_get/1, counter_inc/1, counter_inc/2]).

-behavior(gen_server).

-type state() :: number().
-type message() :: inc | {inc, number()} | {get, pid()}.

start(N) ->
    gen_server:start(counter, 
                    N, % -> init
                    []).

-spec init(number()) -> {ok, state()}.
init(N) -> {ok, N}.

counter_get(Pid) ->
    gen_server:call(Pid, {get, self()}).

counter_inc(Pid) ->
    gen_server:cast(Pid, inc).
counter_inc(Pid, Inc) ->
    gen_server:cast(Pid, {inc, Inc}).

handle_cast(inc, State) ->
    {noreply, State + 1};
handle_cast({inc, Inc}, State) ->
    {noreply, State + Inc}.

handle_call({get, _Pid}, _From, State) ->
    {reply, 
     State, % Antwort
     State}. % neue Zustand
