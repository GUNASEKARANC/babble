-module(mnes).
-export([start/0,reg/2,de_reg/1,name/1,addr/1,addr_all/0,usr_ls/0]).
-include_lib("stdlib/include/qlc.hrl").
-record(users, {name,socket}).

start()->
  %% start mnesia 
  
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(users,[{attributes, record_info(fields, users)}]).

%% register the name and respective socket address

reg(Name, Socket)->
  F=fun()-> 	
	case mnesia:read({users,Name})=:= [] of
	  true->
	    mnesia:write(#users{name=Name,socket=Socket}),
	    {ok,registered};
          false->
	    {error,user_already_in_use}
	end
  end,
  mnesia:activity(transaction,F).

%% deregister name and respective socket address
de_reg(Name)->
  F=fun()->
	case mnesia:read({users,Name})=:= [] of
	  true->
	    {error,not_found};
	  false->
	    mnesia:delete({users,Name}),
	    {ok,deregistered}
	end
  end,
  mnesia:activity(transaction,F).

%% find name of the address

name(Socket)->
 F=fun()->
    Q = qlc:q([E#users.name || E <- mnesia:table(users),E#users.socket==Socket]),
    qlc:e(Q)
  end,
  mnesia:activity(transaction,F).

%% find the socket address by using name 

addr(Name)->
  F=fun()->
    Q = qlc:q([E#users.socket || E <- mnesia:table(users),E#users.name==Name]),
    qlc:e(Q)
  end,
  mnesia:activity(transaction,F).

%% get all users sockets list ,ex: [s1,s2,...]

addr_all()->
  F=fun()->
    Q = qlc:q([E#users.socket || E <- mnesia:table(users)]),
    qlc:e(Q)
  end,
  mnesia:activity(transaction,F).
%% get all users lists	    
usr_ls()->
   F=fun()->
    %%Pattern=#users{_='_',users='$1'},
    %%mnesia:match_object(Pattern)
    %%mnesia:select(users,[{Pattern,[],['$1']}])
    Q = qlc:q([E#users.name || E <- mnesia:table(users)]),
    qlc:e(Q)
  end,
  mnesia:activity(transaction,F).
	    
  
