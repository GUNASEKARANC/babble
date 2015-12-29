-module(decode).
-author("gunamail08@gmail.com").
-export([reciv/1,dec/2]).

%% protocol structured records definition

-record(reg,{name}).
-record(dereg,{name}).
-record(msg,{type,to,body}).


%% recive the binary data from the client socket and converting it to tuples
%% send the tuples to decode 

reciv(Soc)->
  spawn(mnes,start,[]),
  case gen_tcp:recv(Soc,0) of
    {ok, Bin_req}->
	Req=binary_to_term(Bin_req),
	io:format("Request:~p",[Req]),
	decode:dec(Req,Soc),
	reciv(Soc);

  {error, closed} ->
		error
	end.
%% decode the received tuple 
%% identify the which req : reg/dereg/msg
 
dec(Req,Soc) when is_record(Req,reg)->
  dispatch:regis(Req#reg.name,Soc);
	
dec(Req,Soc) when is_record(Req,dereg)->
  dispatch:deregis(Req#dereg.name,Soc);

dec(Req,Soc) when is_record(Req,msg)->
  case Req#msg.type of
    priv->
      dispatch:priv_msg(Soc,Req#msg.to,Req#msg.body);
    bcast->
      dispatch:bcast_msg(Soc,Req#msg.body)
  end;
dec(_,Soc) ->
  gen_tcp:socket(Soc,"unkown_request").
