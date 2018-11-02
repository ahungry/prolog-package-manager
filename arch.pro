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
  rel(X, Y).

% Drill down the path, finding the end node.
chain(X, Ys) :- rel(X, Z), chain(Z, Ys1), append([X], Ys1, Ys).
chain(X, Ys) :- ground(X), Ys = [X].

all_chains(X, S) :- findall(Ys, chain(X, Ys), S).

fold_arrows(X, Y, Z) :- string_concat(X, ' -> ', T), string_concat(T, Y, Z).

arrows([H|T], Z) :- foldl(fold_arrows, T, H, Z).
reversed_arrows(Ls, Z) :- reverse(Ls, Rls), arrows(Rls, Z).

inner_to_outer(X, Ys) :- all_chains(X, Cs), maplist(arrows, Cs, Ys).
outer_to_inner(X, Ys) :- all_chains(X, Cs), reverse(Cs, Rcs), maplist(reversed_arrows, Rcs, Ys).

printer_oti(X) :- maplist(format('~w~n'), outer_to_inner())



list_rels(X, Rl) :-
  findall(Y, rel(X, Y), Rl).

list_rels_recursively(X, Ys) :-
  list_rels(X, Zs),
  format('X is now ~w, with deps: ~n', X),
  write(Zs),nl,
  %maplist(write, Zs),
  maplist(list_rels_recursively, Zs, Xs),
  append([X, Xs], Zs, Ys).
  %append([X, Xs], Zs, Ys).
