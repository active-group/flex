-module(process).
-export([process_code/0, 
         counter_code/1, counter/1, counter_inc/1, counter_inc/2, counter_get/1]).

process_code() ->
    receive % Syntax ist wie case
        "Mike" ->
            io:format("Mike ist da.~n"),
            process_code();
        "Sperber" -> io:format("Sperber ist doof.~n")
    end.

-type counter_message() :: inc | {inc, number()} | {get, pid()}.
counter_code(N) ->
    io:format("counter: ~w~n", [N]),
    receive
        {get, ClientPid} ->
            ClientPid ! N,
            counter_code(N);
        Msg -> counter_code(process_counter_message(N, Msg))
%        inc -> 
%            counter_code(N+1);
%        {inc, Inc} ->
%            counter_code(N+Inc);
    end.

-type counter_state() :: number().

-spec process_counter_message(counter_state(), counter_message()) -> counter_state().
process_counter_message(N, inc) -> N + 1;
process_counter_message(N, {inc, Inc}) -> N + Inc. 

% "Supervisor"
counter(N) ->
    process_flag(trap_exit, true), % exits gelinkter Prozesse werden in Messages umgewandelt
    Pid = spawn_link(process, counter_code, [N]),
    register(counter_service, Pid),
    receive
         {'EXIT', _Pid, _Reason} ->
            counter(N)
    end,
    % link(Pid), % "Wenn Du stirbst, sterbe ich auch. (Und umgekehrt.)"
    Pid.

counter_inc(Pid) ->
    Pid ! inc.

counter_inc(Pid, Inc) ->
    Pid ! {inc, Inc}.

counter_get(ServerPid) ->
    ServerPid ! {get, self()},
    receive 
        N -> N;
     after 5000 -> timeout % ms
     end. 