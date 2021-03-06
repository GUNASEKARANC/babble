-module(client).
-author("guna").
-export([start/0,reciv/1]).
-record(reg,name=test).
-record(dereg,name=test).
start()->
  {ok,S}=gen_tcp:connect({127,0,0,7},9000,[]),
  spwan(client,reciv,[S]).

reciv(S)->
  inet:setopts(S,[{active,once}]),
  case gen_tcp:recv(S,0) of
    {tcp,S,Bin}->
	io:format("~p~n",[Bin]);
    Any->
      io:format("recived:~p~n",[Any]),
      reciv(S)
  end.
  
type(Type,Name,S,To,Msg)->
  case Type of
    priv->
	priv(S,To,Msg);
    bcast->
        bcast(S,To,Msg);
    dereg->
	dereg(Name,S);
    reg->
      reg(Name,S);
    _-> error
  end.
  


reg(Name,S)->  
  Msg={reg,Name},
  send(Msg,S).
dereg(Name,S)->
  Msg={dereg,Name},
  send(Msg,S).
  
priv(S,To,Msg)->
  Con={msg,priv,To,Msg},
  send(Con,S).
bcast(S,To,Msg)->
  Con={msg,bcast,To,Msg},
  send(Con,S).
send(Con,S)->
  M=term_to_binary(Con),
  gen_tcp:send(S,M).
