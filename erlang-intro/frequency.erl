-module(frequency).

% Frequenz-Vergabe
% - gen-server, der eine Menge von Frequenzen verwaltet
% - man kann sich eine freie Frequenz geben lassen
%   (kann sein, daß keine frei ist)
% - man kann Frequenz zurückgeben
%   (muß eine von den verwalteten Frequenzen sein)
% Bonus: darf nur Frequenz zurückgeben, die man 
% vorher bekommen hat

-behavior(gen_server).
-export([init/1, handle_cast/2, handle_call/3,
         start/1, reserve/1, give_back/2]).

-type frequency() :: number().
-record(state, { free :: list(frequency()), 
                 assigned :: dict:dict(frequency(), pid())}).

start(Frequencies) ->
    gen_server:start(?MODULE, Frequencies, [{debug, [trace]}]).

init(Frequencies) ->
    {ok, #state{ free = Frequencies, assigned = dict:new() }}.

handle_cast(_Request, State) ->
    {noreply, State}.

-record(reserve, {}).
-record(give_back, { frequency :: frequency() }).

handle_call(#reserve{}, {FromPid, _}, 
    State = #state { free = Free, assigned = Assigned }) ->
    case Free of
        [] ->
            {reply, 
             none_available,
             State};
        [ First | Rest ] ->
            {reply,
             {ok, First},
             #state { free = Rest, 
                assigned = dict:store(First, FromPid, Assigned)} }
    end;

handle_call(#give_back { frequency = Frequency}, {FromPid, _},
    State = #state { free = Free, assigned = Assigned }) ->
    % io:format("found: ~w~n", [dict:find(Frequency, Assigned)]),
    case dict:find(Frequency, Assigned) of
        {ok, FromPid} ->
            {reply,
             ok,
             #state { free = [ Frequency | Free],
                      assigned = dict:erase(Frequency, Assigned)}};
        {ok, _OtherPid} -> {reply, not_yours, State};
        error -> {reply, not_found, State}
    end.

reserve(Pid) ->
    gen_server:call(Pid, #reserve{}).

give_back(Pid, Frequency) ->
    gen_server:call(Pid, #give_back { frequency = Frequency }).