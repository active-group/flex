-module(inc_server).
-behaviour(gen_server).

% gen_server: Prozeß, der Zustand verwaltet und Messages entgegennimmt.

% inc_server ...
% Zustand: Zähler

-record(inc, {increment :: number()}).
-record(get, { client_pid :: pid() }). % RPC

-type inc_server_message() :: #inc{} | #get{}.

init(InitialN) -> % Anfangswert des Zählers
    {ok, InitialN}. % erste Zustand

