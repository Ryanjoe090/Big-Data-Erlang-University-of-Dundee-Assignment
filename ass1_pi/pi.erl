-module (pi).
-export ([getPi/0]).


getPi() ->
A=4 * (1 - termThingy(3) + termThingy(5)),
io:fwrite("~.5f " , [A]).

termThingy(N) when N > 800000 -> 1/N;
termThingy(N) -> 1/N + termThingy(N+4).  


