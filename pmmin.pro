% Just a file showing the bare minimum to get it working
deps(X,Y) :- dep(X,Y).
deps(X,Y) :- dep(X,Z),
             deps(Z,Y).

list_dependencies(X,Dl) :-
    findall(Y, deps(X,Y), Zl),
    sort(Zl,Dl).

list_requires(Y,Dl) :-
    findall(X, dep(X,Y), Zl),
    sort(Zl,Dl).
