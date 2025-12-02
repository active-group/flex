-module(node_util).
-export([node_from_env/2]).

is_not_at($@) -> false;
is_not_at(_) -> true.

% return hostname of local node, for use in naming other nodes
-spec node_host() -> string().
node_host() ->
    S = atom_to_list(node()),
    [_ | Host] = lists:dropwhile(fun is_not_at/1, S),
    Host.


% returns node name where host is either from env var or same
% as this node
-spec node_from_env(atom(), string()) -> node().
node_from_env(SName, HostEnvVar) ->
    Host = case os:getenv(HostEnvVar) of
                false -> node_host();
                H -> H
           end,
    list_to_atom(atom_to_list(SName) ++ "@" ++ Host).

