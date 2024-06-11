-module(inc_server).
-behaviour(gen_server).
-export([init/1]).

% gen_server: Prozeß, der Zustand verwaltet und Messages entgegennimmt.

% inc_server ...
% Zustand: Zähler

-record(inc, {increment :: number()}). % fire-and-forget
-record(get, { client_pid :: pid() }). % RPC

-type inc_server_message() :: #inc{} | #get{}.

-type inc_server_state() :: number().

init(InitialN) -> % Anfangswert des Zählers
    {ok, InitialN}. % erste Zustand

% call: RPC
% cast: "fire-and-forget"
% 

-spec handle_call(#get{}, pid(), inc_server_state()).
handle_call(Request, From, State) -> todo.