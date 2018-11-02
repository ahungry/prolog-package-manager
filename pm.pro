%:- module(pm, [public/2]).
%:- use_module(packages).

% general seek
deps(X,Y) :-
    dep(X,Y).
deps(X,Y) :-
    dep(X,Z),
    deps(Z,Y,[]).

% x branch - need to prevent cyclic loop
deps(X,Y,S) :-
    ground(X),
    \+member(X,S),
    append([X],S,T),
    dep(X,Z),
    deps(Z,Y,T).
deps(X,Y,_) :-
    ground(X),
    dep(X,Y).

% y branch - need to prevent cyclic loop
deps(X,Y,S) :-
    ground(Y),
    \+member(Y,S),
    append([Y],S,T),
    dep(X,Z),
    deps(Z,Y,T).

list_dependencies(X,Dl) :-
    findall(Y, dep(X,Y), Zl),
    list_unique(Zl,Dl).

list_requires(Y,Dl) :-
    findall(X, dep(X,Y), Zl),
    list_unique(Zl,Dl).

% this is still pretty fast
list_all_dependencies(X,Dl) :-
    findall(Y, deps(X,Y), Zl),
    list_unique(Zl,Dl).

% this can get pretty slow
list_all_requires(Y,Dl) :-
    findall(X, deps(X,Y,[]), Zl),
    list_unique(Zl,Dl).

% list_unique/2
list_unique([],[]).
list_unique([X|T], R) :-
    list_unique(T,[X],R).

% list_unique/3
list_unique([], R, R).
list_unique([X|T],L,R) :-
    \+member(X,L),
    append([X],L,Z),
    list_unique(T,Z,R).
list_unique([X|T],L,R) :-
    member(X,L),
    Z = L,
    list_unique(T,Z,R).
