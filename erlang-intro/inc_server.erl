-module(inc_server).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2,
         inc_server_get/1, inc_server_inc/2]).

% gen_server: Prozeß, der Zustand verwaltet und Messages entgegennimmt.

% inc_server ...
% Zustand: Zähler

-record(inc, {increment :: number()}). % fire-and-forget
-record(get, {}). % RPC

-type inc_server_message() :: #inc{} | #get{}.

-type inc_server_state() :: number().

init(InitialN) -> % Anfangswert des Zählers
    {ok, InitialN}. % erste Zustand

% call: RPC
% cast: "fire-and-forget"
% 

-spec handle_call(#get{}, pid(), inc_server_state()) -> 
         {reply, {ok, inc_server_state()}, inc_server_state()}.
handle_call(#get{}, _From, N) ->
 {reply, 
  {ok, N}, % Antwort
  N}. % neuer Zustand

-spec handle_cast(#inc{}, inc_server_state()) ->
    {noreply, inc_server_state()}.
handle_cast(#inc{increment = Inc}, N) ->
    {noreply, N+Inc}.

-spec inc_server_get(pid()) -> {ok, inc_server_state()}.
inc_server_get(Pid) ->
    gen_server:call(Pid, #get{}). % nicht mehr ! direkt benutzen

inc_server_inc(Pid, Inc) ->
    gen_server:cast(Pid, #inc{increment=Inc}).

inc_server_start(InitialN) ->
    gen_server:start(?MODULE, 
                     InitialN,  % geht an init
                     []).