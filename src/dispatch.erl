-module(dispatch).
-author("guna").
-export([regis/2,deregis/2,priv_msg/3,bcast_msg/2,ack/1]).

regis(Name,Soc)->
  Res=mnes:reg(Name,Soc),
  io:format("~p~n",[Res]),
  case Res of
    {ok,registered} ->
	Con=encode:online_usrs(),
	gen_tcp:send(Soc,Con);
    {error,user_already_in_use} ->
        gen_tcp:send(Soc,"alreday in use\n")
  end.

deregis(Name,Soc)->
  Res=mnes:de_reg(Name),
  io:format("~p~n",[Res]),
  case Res of
    {ok,deregistered}->
      gen_tcp:send(Soc,"deregistered");

    {error,not_found}->
       gen_tcp:send(Soc,"unknown user")
  end.
	
priv_msg(Soc,To_name,Msg) ->
	From=name(Soc),
	To=addr(To_name),
	Con=encode:format_str(From,Msg),
	gen_tcp:send(To,Con),
	dispatch:ack(Soc).
bcast_msg(Soc,Msg) ->
	From=name(Soc),
	To=mnes:usr_ls(),
	Con=encode:format_str(From,Msg),
	lists:foreach(fun(S)->gen_tcp:send(S,Con) end,To),
	dispatch:ack(Soc).
name(Addr)->
  mnes:name(Addr).
addr(Name)->
  mnes:addr(Name).
ack(Addr)->
  gen_tcp:send(Addr,"sent").