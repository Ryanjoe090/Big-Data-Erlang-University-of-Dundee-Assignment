-module (filter).
-export ([filter/1]).
-export ([getUnique/1]).
-export ([readlines/1]).


getUnique([H|T]) ->
A=filter([H|T]),
{A,length(A)}.


filter([]) -> [];
filter([H|T]) ->
filter([X||X <- T, X /=H])++[H].

%"readlines" function adapted from http://stackoverflow.com/questions/2475270/how-to-read-the-contents-of-a-file-in-erlang
readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try io:fwrite(" ~p~n", [getUnique(get_all_lines(Device))])
      after file:close(Device)
    end.
    
get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> string:tokens(string:to_lower(Line), " .,;:!?ï»¿~/><{}Â£$%^&()@-=+_[]*#\\\n\r\"0123456789") ++ get_all_lines(Device)
    end.

