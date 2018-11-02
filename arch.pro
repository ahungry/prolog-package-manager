% Track some system/architecture level dependencies

% Prefixes: w = website, d = database, c = app code, a = api

% Systems (things)
sys(c_ahungry).
sys(c_langpop).
sys(d_mysql).
sys(w_ahungry).
sys(w_p99wiki).

% Hosts
host(c_ahungry, 'ahungry.com').
host(c_langpop, 'ahungry.com').
host(d_mysql, 'ahungry.com').
host(w_ahungry, 'ahungry.com').
host(w_langpop, 'ahungry.com').
host(w_p99wiki, 'wiki.project1999.com').

% Ports
port(c_ahungry, 5000).
port(c_langpop, 5100).
port(d_mysql, 3306).
port(w_ahungry, 80).
port(w_langpop, 80).
port(w_p99wiki, 443).

% System relations.
rel(w_ahungry, w_p99wiki).
rel(w_ahungry, c_ahungry).
rel(c_ahungry, d_mysql).
rel(w_langpop, c_langpop).

rels(X, Y) :-
  rel(X, Y).

rels(X, Y) :-
  rel(X, Z),
  rels(Z, Y, []).

rels(X,Y,S) :-
  ground(X),
  \+member(X, S),
  append([X], S, T),
  rel(X, Z),
  rels(Z, Y, T).

rels(X, Y, _) :-
  ground(X),
  dep(X, Y).

list_rels(X, Rl) :-
  findall(Y, rels(X, Y), Rl).

list_rels_recursively(X, Ys) :-
  list_rels(X, Zs),
  %maplist(write, Zs),
  maplist(list_rels_recursively, Zs, Xs),
  append([X, Zs], Xs, Ys).
