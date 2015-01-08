%:- initialization(main).

pp(X,_) :- write(X),nl.

main :-
    list_all_dependencies(firefox,D),
    write(firefox),write(' depends on:'),nl,
    maplist(pp,D,Dl),
    nl,write(firefox),write(' provides:'),nl,
    list_requires(firefox,P),
    maplist(pp,P,Pl),
    halt.

main_deps(X) :-
    list_all_dependencies(X,D),
    write(X),write(' depends on:'),nl,
    maplist(pp,D,Dl),
    halt.

main_reqs(X) :-
    list_requires(X,P),
    write(X),write(' provides:'),nl,
    maplist(pp,P,Pl),
    halt.
