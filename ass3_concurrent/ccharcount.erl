-module (ccharcount).
-export ([main/1,load/2,count/3,go/2,join/2,split/2,goSpawn/2, countsplit/2]).
%"Create function that joins the lists"
%"Spawn that and pass it's pid to each of the counter processes"
%example 3 in video/sides is cooool goshake

main(F) -> {ok,Bin} = file:read_file(F),
   List=binary_to_list(Bin),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   load(Sl,length(List)/20).

goSpawn(CountSplitPid,[]) -> atomd;
goSpawn(CountSplitPid,[H|T]) ->
spawn(ccharcount,go, [CountSplitPid,H]),
goSpawn(CountSplitPid,T).

load(List, Length) when Length < 1 ->io:fwrite("Give Longer File Please~n");
load(List, Length)->
   io:fwrite("Loaded and Split~n"),
   CountSplitPid=spawn(ccharcount,countsplit,[[],0]),
   goSpawn(CountSplitPid, List).
% Result.

%PATTERN MATCHED PRINT AT END
countsplit(R,20)->
  receive
 	{List} ->
 		R2 = join(R, List),
 		io:fwrite(" ~p~n", [R2]),
 		countsplit(R2,20+1);
 	_Other -> {error, unknown}
 end;
 
%countsplit([])->[];
countsplit(R,N)->
  receive
 	{List} ->
 		R2 = join(R, List),
 		%io:fwrite(" ~p~n", [R2]),
 		countsplit(R2,N+1);
 	_Other -> {error, unknown}
 end.

join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
{C,N}=H1,
{C1,N1}=H2,
[{C1,N+N1}]++join(T1,T2).

split([],_)->[];
split(List,Length)->
S1=string:substr(List,1,Length),
case length(List) > Length of
   true->S2=string:substr(List,Length+1,length(List));
   false->S2=[]
end,
[S1]++split(S2,Length).

count(Ch, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.

go(Pid, L)->
Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
Pid ! {rgo(Alph,L,[])}.

rgo([H|T],L,Result)->
N=count(H,L,0),
Result2=Result++[{[H],N}],
rgo(T,L,Result2);

rgo([],L,Result)->Result.
