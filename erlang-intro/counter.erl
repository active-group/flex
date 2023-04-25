-module(counter).
-export([init/1, handle_cast/2, handle_call/3, start/1]).

-behavior(gen_server).

-record(inc_by, {increment :: integer() }).
-record(get, {requester :: pid()}).

-type message() :: inc | #inc_by{} | #get{}.

% State of our counter server
-type state() :: integer().

start(InitialN) ->
    gen_server:start(?MODULE, InitialN, 
       [{debug, [trace]}]).

-spec init(state()) -> {ok, state()}.
init(InitialState) -> % is just InitialN from start(...)
    {ok, InitialState}.

-spec handle_cast(message(), state()) -> {noreply, state()}.
handle_cast(inc, N) -> {noreply, N+1};
handle_cast(#inc_by{ increment = Inc }, N) ->
     {noreply, N+Inc}.

-spec handle_call(message(), pid(), state()) -> 
    {reply, integer(), state()}.
handle_call(#get{requester = _Req }, _From, N) ->
    {reply, 
     N, % reply
     N}.

counter_inc(Pid, Inc) ->
    gen_server:cast(Pid, #inc_by{increment = Inc}).

counter_get(Pid) ->
    gen_server:call(Pid, #get{requester = dummy}).
