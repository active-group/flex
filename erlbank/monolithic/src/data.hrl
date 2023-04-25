-type unique_id() :: integer().
-type account_number() :: integer().
-type money() :: number().

-record(person, 
    {id :: unique_id(), 
     given_name :: binary(),
     surname :: binary()}).
-record(account,
    {account_number :: account_number(),
     person_id :: unique_id(),
     amount :: money()}).
-record(transfer, 
    {id :: unique_id(), 
     timestamp :: erlang:timestamp(), 
     from_account_number :: account_number(),
     to_account_number :: account_number(),
     amount :: money()}).
