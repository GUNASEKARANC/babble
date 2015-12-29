-module(tcp_serv).
-author("guna").
-export([start/0,accept_loop/1]).
-define(Port,9000).

start()->
    {ok,Lsocket}=gen_tcp:listen(?Port,[binary,{active,false}]),
    spawn(tcp_serv,accept_loop,[Lsocket]),
    timer:sleep(infinity).
accept_loop(Lsocket)->
  {ok, Asocket}=gen_tcp:accept(Lsocket),
  spawn(decode,reciv,[Asocket]),
  tcp_serv:accept_loop(Lsocket).

