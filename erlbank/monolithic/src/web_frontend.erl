
-module(web_frontend).
-include("data.hrl").
-export([init/2]).



account_opened_success() ->
    << "
      <p> Account with account number ~p was opened successfully </p> ~n
       <a href=\"/\"> Back </a>
    " >>.


account_open_form() ->
            << "
<h3> Open Account </h3>
               <form method=\"post\" action=\"/accounts/open\">
  <label for=\"accounts_givenName\"> Given Name </label>
  <input type=\"text\" id=\"accounts_givenName\" name=\"accounts_givenName\" />

  <label for=\"accounts_surname\"> Surname </label>
  <input type=\"text\" id=\"accounts_surname\" name=\"accounts_surname\" />

  <input type=\"submit\" value=\"Open account\" />
</form>" >>.


-spec bin_to_int(binary()) -> integer().
bin_to_int(B) ->
    erlang:list_to_integer(binary:bin_to_list(B)).

-spec transfer_error() -> binary().
transfer_error() ->
    << "
      <p> An error occured: ~p </p> ~n
       <a href=\"/\"> Back </a>
    " >>.

-spec transfer_success() -> binary().
transfer_success() ->
            << "
      <p> Transfer with id ~p successfully created </p> ~n
               <a href=\"/\"> Back </a>
    " >>.


transfer_form() ->
                    << "
<h3> Create transfer </h3>
                       <form method=\"post\" action=\"/transfers/create\">
  <label for=\"transfers_from\"> From (account number) </label>
  <input type=\"text\" id=\"transfers_from\" name=\"transfers_from\" />

  <label for=\"transfers_to\"> To (account number) </label>
  <input type=\"text\" id=\"transfers_to\" name=\"transfers_to\" />

  <label for=\"transfers_amount\"> Amount </label>
  <input type=\"text\" id=\"transfers_amount\" name=\"transfers_amount\" />

  <input type=\"submit\" value=\"Create transfer\" />
</form>" >>.



statement_form() ->
    << "
<h3> Request statement </h3>
  <form method=\"post\" action=\"/statements/request\">
  <table>
       <tr>
       <td>
         <label for=\"statement_accountnumber\"> Account number </label>
       </td>
       <td>
         <input type=\"text\" id=\"statement_accountnumber\" 
                name=\"statement_accountnumber\" />
       </td>
       </tr>

       <tr>
       <td>
         <label for=\"statement_currency\"> Currency </label>
       </td>
       <td>
         <input type=\"text\" id=\"statement_currency\" name=\"statement_currency\"
                value=\"EUR\" size=3/>
       </td>
       </tr>

       <tr>
       <td>
         <label for=\"statement_format\"> Number & date formatting </label>
       </td>
       <td>
         <select id=\"statement_format\" name=\"statement_format\">
           <option value=\"de\" selected>DE</option>
           <option value=\"en\">EN</option>
         </select>
       </td>
       </tr>
   </table>

  <input type=\"submit\" value=\"Request statement\" />
</form>" >>.


-spec transfer_template() -> string().
transfer_template() ->
    "<tr>
      <td> ~p </td>
      <td> ~s </td>
      <td> ~s </td>
      <td> ~s </td>
      <td> ~s </td>
    </tr>".

-spec amount_to_string(money(), string(), number_formatter:locale()) -> string().
amount_to_string(Amount, Currency, Format) ->
    {ok, AmountExchanged} = exchange_service:exchange(Currency, Amount),
    AmountFormatted = number_formatter:format(Format, AmountExchanged),
    AmountFormatted ++ " " ++ Currency.


%% returns the name of the person associated to the account nr
%% given by account number.
-spec name_by_account_number(unique_id()) -> string().
name_by_account_number(AccountNumber) ->
    {ok, Account} = business_logic:get_account(AccountNumber),
    name_by_account(Account).

%% returns the name of the person associated to the account
%% given by account.
-spec name_by_account(#account{}) -> string().
name_by_account(Account) ->
    {ok, Person}  = business_logic:get_person(Account#account.person_id),
    io_lib:format("~s ~s", [Person#person.given_name, Person#person.surname]).

-spec transfer(#transfer{}, string(), number_formatter:locale()) -> string().
transfer(Transfer, Currency, Format) ->
    Name1 = name_by_account_number(Transfer#transfer.from_account_number),
    Name2 = name_by_account_number(Transfer#transfer.to_account_number),
    Amount = amount_to_string(Transfer#transfer.amount, Currency, Format),
    Date = date_formatter:format(Format, Transfer#transfer.timestamp),
    Id = Transfer#transfer.id,
    io_lib:format(transfer_template(), [Id, Date, Amount, Name1, Name2]).

head_template() ->
    "<p> Name: ~s </p>
     <p> Balance: ~s </p>
     <table>
      <tr>
        <th>ID</th>
        <th>Date</th>
        <th>Amount</th>
        <th>Sender</th>
        <th>Receiver</th>
      </tr> ".

back_button() ->
    "<a href=\"/\">Back </a>".

footer_template() ->
    "</table>" ++ back_button().


-spec head(#account{}, string(), number_formatter:locale()) -> string().
head(Account, Currency, Format) ->
    Amount = amount_to_string(Account#account.amount, Currency, Format),
    Name =  name_by_account(Account),
    io_lib:format(head_template(), [Name, Amount]).

-spec statement(#account{}, list(#transfer{}), string(), number_formatter:locale()) -> string().
statement(Account, Transfers, Currency, Format) ->
    % TODO append all transfers
    TransfersString = lists:foldl(fun(Transfer, Acc) -> Acc ++ transfer(Transfer, Currency, Format) end, "", Transfers),
    io_lib:format("~s ~s ~s", [head(Account, Currency, Format), TransfersString, footer_template()]).


index() ->
    io_lib:format("~s~s~s",
                  [account_open_form(),
                   transfer_form(),
                   statement_form()]).

%% /statements/request
init(Request, request_statement) ->

    {ok, KeyValuesL, _} = cowboy_req:read_urlencoded_body(Request),

    KeyValues = maps:from_list(KeyValuesL),
    AccountNumber = bin_to_int(maps:get(<<"statement_accountnumber">>, KeyValues)),
    Currency = binary_to_list(maps:get(<<"statement_currency">>, KeyValues)),
    Format = list_to_atom(
               binary_to_list(maps:get(<<"statement_format">>, KeyValues))),

    logger:info("Bank statement request: account number ~p~n", [AccountNumber]),
    Ret = business_logic:get_account(AccountNumber),
    KnowsCurrency = exchange_service:knows_currency(Currency),
    case {KnowsCurrency, Ret} of
        {true, {ok, Account}} ->
            Transfers = business_logic:get_transfers(AccountNumber),
            Body = statement(Account, Transfers, Currency, Format),
            Reply = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>},
                                    Body, Request),
            {ok, Reply, []};
        {false, _} ->
            Reply = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>},
                                    "Currency not found.<br/>" ++ back_button(), Request),
            {ok, Reply, []};
        {_, {error, not_found}} ->
            Reply = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>},
                                    "Account not found.<br/>" ++ back_button(), Request),
            {ok, Reply, []}
    end;


%% /transfers/create
init(Request, create_transfer) ->

    {ok, KeyValuesL, _} = cowboy_req:read_urlencoded_body(Request),

    KeyValues = maps:from_list(KeyValuesL),
    SenderAccountNumber =  bin_to_int(maps:get(<<"transfers_from">>, KeyValues)),
    ReceiverAccountNumber = bin_to_int(maps:get(<<"transfers_to">>, KeyValues)),
    Amount = bin_to_int(maps:get(<<"transfers_amount">>, KeyValues)),

    Body = case business_logic:transfer(SenderAccountNumber, ReceiverAccountNumber, Amount) of
               {ok, TransferId} ->
                   io_lib:format(transfer_success(), [TransferId]);
               {error, Error} ->
                   io_lib:format(transfer_error(), [Error])
           end,
    Reply = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Request),
    {ok, Reply, []};

%% /accounts/open
init(Request, open_account) ->

    logger:info("Creating new account"),

    {ok, KeyValuesL, _} = cowboy_req:read_urlencoded_body(Request),

    KeyValues = maps:from_list(KeyValuesL),
    GivenName = maps:get(<<"accounts_givenName">>, KeyValues),
    Surname = maps:get(<<"accounts_surname">>, KeyValues),

    Account = business_logic:open_account(GivenName, Surname),
    Body = io_lib:format(account_opened_success(), [Account#account.account_number]),

    Reply = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Request),

    logger:info("Created account with account number ~p", [Account#account.account_number]),

    {ok, Reply, []};

%% /index
init(Request, index) ->
    Reply = cowboy_req:reply(200,
                           #{<<"content-type">> => <<"text/html">>},
                           index(),
                           Request),
    {ok, Reply, []}.
