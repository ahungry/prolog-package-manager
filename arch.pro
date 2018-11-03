% -*- mode: prolog -*-

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

% Drill down the path, finding the end node.
% This recursively does the chain, maybe overkill for dot output, as we
% can iterate over all nodes quite easily.
%chain(X, Ys) :- rel(X, Z), chain(Z, Ys1), append([X], Ys1, Ys).
chain(X, Ys) :- rel(X, Z), append([X], [Z], Ys).
chain(X, Ys) :- ground(X), Ys = [X].

all_chains(X, S) :- findall(Ys, chain(X, Ys), S).

fold_arrows(X, Y, Z) :- string_concat(X, ' -> ', T), string_concat(T, Y, Z).

arrows([H|T], Z) :- foldl(fold_arrows, T, H, Z).
reversed_arrows(Ls, Z) :- reverse(Ls, Rls), arrows(Rls, Z).

inner_to_outer(X, Ys) :- all_chains(X, Cs), maplist(arrows, Cs, Ys).
outer_to_inner(X, Ys) :- all_chains(X, Cs), reverse(Cs, Rcs), maplist(reversed_arrows, Rcs, Ys).

printer_oti(X) :-
  outer_to_inner(X, Ys),
  maplist(format('~w~n'), Ys).

printer_ito(X) :-
  inner_to_outer(X, Ys),
  maplist(format('~w~n'), Ys).

prop(Goal, Set) :-
  findall(X, sys(X), Systems),
  maplist(Goal, Systems, Set).

hosts(Hosts) :- prop(host, Hosts).
ports(Ports) :- prop(port, Ports).

make_dot_file() :-
  format('digraph Application {~nrankdir=LR;~nnode [shape=box,style=filled,fillcolor="#C0D0C0"];~n'),
  findall(X, sys(X), Systems),
  maplist(printer_oti, Systems),
  format('}~n').
