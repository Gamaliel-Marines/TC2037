lasto(X, [X]).
lasto(X, [_|T]) :- lasto(X, T).