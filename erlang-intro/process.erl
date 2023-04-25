-module(process).
-export([counter_code/1, counter_next/2,
         counter_inc/1, counter_inc/2,
         counter_get/1,
         start_counter/1]).

% Eine Nachricht an counter_code ist eins der folgenden:
% - inc - ODER -
% - inc-by-Record

-record(inc_by, {increment :: integer() }).
-record(get, {requester :: pid()}).

-type message() :: inc | #inc_by{} | #get{}.

% Zähler-Prozess
counter_code(N) ->
    io:format("counter: ~w~n", [N]),
    receive
%        inc ->
%            io:format("counter: ~w~n", [N]),
%            counter_code(N+1);
%        #inc_by{ increment = Inc } ->
%            io:format("counter: ~w~n", [N]),
%            counter_code(N+Inc);
%        #get{requester = Req } ->
%            Req ! N,
%            counter_code(N)
        Message ->
            counter_code(counter_next(N, Message))
    end.

-spec counter_next(integer(), message()) -> integer().
counter_next(N, Message) ->
    case Message of
        inc ->
            N+1;
        #inc_by{ increment = Inc } ->
            N+Inc;
        #get{requester = Req } ->
            Req ! N,
            N
    end.

counter_inc(Pid) -> Pid ! inc.

counter_inc(Pid, Inc) ->
    Pid ! #inc_by{increment = Inc},
    ok.

counter_get(Pid) ->
    Pid ! #get{requester = self() },
    receive
        N -> N
    end.

% self(): Pid des laufenden Prozesses
% 
start_counter(N) ->
    % don't die if a linked process dies, instead receive a message
    process_flag(trap_exit, true),
    Pid = spawn_link(process, counter_code, [N]),
    register(inc_service, Pid),
    % spawn_link: spawn + link atomically
    % sorgt dafür, daß, wenn Pid stirbt, auch dieser Prozess stirbt
    % und umgekehrt
    % link(Pid),
    io:format("pid: ~w~n", [Pid]),
    receive
        {'EXIT', _Pid, _Reason} ->
            io:format("restarting counter~n"),
            start_counter(N);
        Msg -> io:format("received message: ~w~n", [Msg])
    end,    
    Pid.