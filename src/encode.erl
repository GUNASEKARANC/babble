-module(encode).
-author("guna").
-export([online_usrs/0,format_str/2]).

%% registered users/online users

online_usrs()->
  List=mnes:usr_ls(),
  io:format("~p~n",[List]),
  L="Online users: " ++ List ++ "\n",
  list_to_bin(L).

%% called from dipatch priv_msg/bcast_msg
%% return Y/M/D, [ H:Mi ] - From: Msg
%% From->atom Msg->string list
format_str(From,Msg)->
  L=timestamp()++atom_to_list(From)++": "++Msg,
  list_to_bin(L).

%% returns the date and time
timestamp()->
  {{Y,M,D},{H,Mi,_}}=erlang:localtime(),
  integer_to_list(Y)++"/"++integer_to_list(M)++"/"++integer_to_list(D)++",[ "++integer_to_list(H)++":"++integer_to_list(Mi)++" ] - ".

list_to_bin(L)->
  term_to_binary(L).