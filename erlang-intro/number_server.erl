-module(number_server).

-behavior(gen_server).

-export([init/1,
         handle_cast/2,
         handle_call/3,
         start/1]).

start(InitialN) ->
    gen_server:start(number_server, InitialN, []).

init(InitialN) ->
    {ok, InitialN}.

% cast: asynchrone Nachricht an den Server
% call: RPC mit Antwort

% Cast:
-record(add, { inc :: number()}).

handle_cast(#add{ inc = Inc}, N) ->
    {noreply, N + Inc}.


% Call:
-record(query, {}).

handle_call(#query {}, _From, N) ->
    {reply,
     N,  % Antwort
     N  }. % neuer Zustand