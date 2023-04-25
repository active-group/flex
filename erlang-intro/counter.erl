-module(counter).

-behavior(gen_server).

-record(inc_by, {increment :: integer() }).
-record(get, {requester :: pid()}).

-type message() :: inc | #inc_by{} | #get{}.
