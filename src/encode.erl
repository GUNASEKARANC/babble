-module(encode).
-author("guna").
-export([online_usrs/0,format_str/2]).

%% registered users/online users

online_usrs()->
  List=mnes:usr_ls(),
  io:format("~p~n",[List]),
  "Online users: " ++ List ++ "\n".

%% called from dipatch priv_msg/bcast_msg
%% return Y/M/D, [ H:Mi ] - From: Msg

format_str(From,Msg)->
  timestamp()++From++": "++Msg++"\n".

%% returns the date and time
timestamp()->
  {{Y,M,D},{H,Mi,_}}=erlang:localtime(),
  integer_to_list(Y)++"/"++integer_to_list(M)++"/"++integer_to_list(D)++", [ "++integer_to_list(H)++":"++integer_to_list(Mi)++" ] - ".
