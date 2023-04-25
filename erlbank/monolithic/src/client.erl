%% This module represents the frontend layer

-module(client).
-include("data.hrl").
-export([open_account/2, transfer/3, statement/1]).



%% returns the name of the person associated to the account 
%% given by account number.
-spec name_by_account_number(account_number()) -> string().
name_by_account_number(AccountNumber) ->
    {ok, Account} = business_logic:get_account(AccountNumber),
    {ok, Person}  = business_logic:get_person(Account#account.person_id),
    binary_to_list(Person#person.given_name) ++ " " ++ binary_to_list(Person#person.surname).


%% opens an acocunt with a given name and surname.
%% prints the result and the account number to stdout.
-spec open_account(string(), string()) -> ok.
open_account(GivenName, Surname) ->
    Account = business_logic:open_account(list_to_binary(GivenName),
                                          list_to_binary(Surname)),
    io:format("Account was successfully opened. Account number: ~p ~n", [Account#account.account_number]).


%% transfers a given amount from the first account to the second account, identified
%% by their account number. Prints the transfer-id when successful, else the error
%% to stdout.
-spec transfer(account_number(), account_number(), money()) -> ok.
transfer(SenderAccountNumber, ReceiverAccountNumber, Amount) ->
    case business_logic:transfer(SenderAccountNumber, ReceiverAccountNumber, Amount) of
        {ok, TransferId} ->
            io:format("Transfer successful, id: ~p~n", [TransferId]);
        {error, Error} ->
            io:format("An error occured: ~p~n", [Error])
        end.



%% prints the header of a bank statement, namely the full name and the
%% current balance, associated with the account number to stdout.
print_head(AccountNumber) ->
    {ok, Account} = business_logic:get_account(AccountNumber),
    Name = name_by_account_number(AccountNumber),
    io:format("~nBank statement for: ~s~n", [Name]),
    io:format("---------------------------------------------------- ~n", []),
    io:format("Balance: ~p~n", [Account#account.amount]),
    io:format("---------------------------------------------------- ~n", []).


%% takes a transfer record and prints it to stdout.
print_transfer(Transfer) ->
    Name1 = name_by_account_number(Transfer#transfer.from_account_number),
    Name2 = name_by_account_number(Transfer#transfer.to_account_number),
    Amount = Transfer#transfer.amount,
    Id = Transfer#transfer.id,
    io:format("#~p\t ~p\t ~s \t -> ~s ~n", [Id, Amount, Name1, Name2]).

%% takes a list of transfers records and prints them to stdout
print_transfers(Transfers) ->
    lists:map(fun print_transfer/1, Transfers).


%% takes an account number and prints a bank statement to stdout.
%% That is a full name, the current balance, and a list of
%% transfers associated with the account.
statement(AccountNumber) ->
    Transfers = business_logic:get_transfers(AccountNumber),
    SortedRelevantTransfers = business_logic:sort_transfers(Transfers),

    print_head(AccountNumber),
    print_transfers(SortedRelevantTransfers),

    io:format("~n~n", []).
