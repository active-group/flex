-module(number_server).

-behavior(gen_server).

-export([init/1,
         handle_cast/2]).

init(InitialN) ->
    {ok, InitialN}.

% cast: asynchrone Nachricht an den Server
% call: RPC mit Antwort

% Cast:
-record(add, { inc :: number()}).

handle_cast(#add{ inc = Inc}, N) ->
    {noreply, N + Inc}.


% Call:
-record(query, { sender_pid :: pid() }).