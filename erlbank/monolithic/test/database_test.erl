-module(database_test).
-include_lib("eunit/include/eunit.hrl").
-include("data.hrl").

setup() ->
    database:init_database().

cleanup(_) -> ok.

main_test_() ->
    {inorder,
     {foreach,
      fun setup/0,
      fun cleanup/1,
      [fun put_person/1, fun put_account/1,
       fun put_transfer/1, fun get_transfers_from/1]
     }}.

put_person(_) ->
    fun() ->
            Person = #person{id = 15, given_name = <<"Mike">>, surname = <<"Sperber">>},
            database:put_person(Person),
            ?assertEqual(database:get_person(15), {ok, Person}),
            ?assertEqual(database:get_all_persons(), [Person])
    end.

put_account(_) ->
    fun() ->
            Account = #account{account_number = 42, person_id = 17, amount = 100 },
            database:put_account(Account),
            ?assertEqual(database:get_account(42), {ok, Account}),
            ?assertEqual(database:get_all_accounts(), [Account])
    end.

put_transfer(_) ->
    fun() ->
            Transfer = #transfer{id = 17, timestamp = {1610,547469,326863}, from_account_number = 17, to_account_number = 32, amount = 100 },
            database:put_transfer(Transfer),
            ?assertEqual(database:get_transfer(17), {ok, Transfer}),
            ?assertEqual(database:get_all_transfers(), [Transfer]),
            ?assertEqual(database:get_all_transfers(17), [Transfer]),
            ?assertEqual(database:get_all_transfers(16), [])
    end.

get_transfers_from(_) ->
    fun() ->
            Transfer1 = #transfer{id = 17, timestamp = {1610,547469,326863}, from_account_number = 17, to_account_number = 32, amount = 100 },
            database:put_transfer(Transfer1),
            Transfer2 = #transfer{id = 18, timestamp = {1610,547469,326864}, from_account_number = 18, to_account_number = 33, amount = 1000 },
            database:put_transfer(Transfer2),
            ?assertEqual([Transfer1, Transfer2],
                database:get_transfers_from(16)),
            ?assertEqual([Transfer1, Transfer2],
                database:get_transfers_from(17)),
            ?assertEqual([Transfer2],
                database:get_all_transfers(18)),
            ?assertEqual([],
                database:get_transfers_from(19))
    end.





