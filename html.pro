% prolog file for string handling and html?

html.
head.
body.
p.
div(Id) :-
    maplist(write, [' id="',
		    Id,'"']).
script(Src) :-
    maplist(write, [' type="text/javascript" src="',
		    Src,'.js"']).
link(Href) :-
    maplist(write, [' type="text/css" rel="stylesheet" href="',
		    Href,'.css"']).

eval(_).
tags([]).
tags([T|Ags]) :-
    is_list(T),
    \+member(eval,T),
    tags(T),
    tags(Ags).
tags([T|Ags]) :-
    is_list(T),
    member(eval,T),
    maplist(call,T),
    tags(Ags).
tags([T|Ags]) :-
    \+is_list(T),
    write('<'),write(T),call(T),write('>\n'),
    tags(Ags),
    write('</'),write(T),write('>\n').

header(X) :-
    X = [html,
	 [head,
	  [script('some')],
	  [link('some')]]].

page(home,X) :-
    header(Z),
    append(Z, [body, [div('myid'), 
		      [p, 
		       [eval, write('This is interesting...')]]
	      ]], X).

render(Page) :-
    page(Page,Html),
    tags(Html).
