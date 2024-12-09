-module(date_formatter).

-export([format/2]).

-type year() :: integer().
-type month_number() :: pos_integer().
-type day_number() :: pos_integer().
-type timestamp() :: {year(), month_number(), day_number()}.

-spec month_en(month_number()) -> string().
month_en(MonthNumber) ->
    case MonthNumber of
        1 -> "January";
        2 -> "February";
        3 -> "March";
        4 -> "April";
        5 -> "May";
        6 -> "June";
        7 -> "July";
        8 -> "August";
        9 -> "September";
        10 -> "October";
        11 -> "November";
        12 -> "December"
    end.

-spec month_de(month_number()) -> string().
month_de(MonthNumber) ->
    case MonthNumber of
        1 -> "Januar";
        2 -> "Februar";
        3 -> "März";
        4 -> "April";
        5 -> "Mai";
        6 -> "Juni";
        7 -> "Juli";
        8 -> "August";
        9 -> "September";
        10 -> "Oktober";
        11 -> "November";
        12 -> "Dezember"
    end.

-spec day_en(day_number()) -> string().
day_en(DayNumber) ->
    case DayNumber of
        1 -> "1st";
        2 -> "2nd";
        _ -> integer_to_list(DayNumber) ++ "th"
    end.

    
-spec format_en(timestamp()) -> string().
format_en({Year, MonthNumber, DayNumber}) ->
    month_en(MonthNumber) ++ " " ++ day_en(DayNumber) ++ ", " ++ integer_to_list(Year).


-spec format_de(timestamp()) -> string().
format_de({Year, MonthNumber, DayNumber}) ->
    integer_to_list(DayNumber) ++ ". " ++ month_de(MonthNumber) ++ ", " ++ integer_to_list(Year).


-spec format(en | de, timestamp()) -> string().
format(en, Timestamp) ->
    {Date, _} = calendar:now_to_datetime(Timestamp),
    format_en(Date);
format(de, Timestamp) ->
    {Date, _} = calendar:now_to_datetime(Timestamp),
    format_de(Date).
