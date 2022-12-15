:- dynamic(point/2).

% Input facts
:- [input].

% Derived facts
vertical_line(X, Y1, Y2) :- line(X, Y1, X, Y2).
horizontal_line(X1, X2, Y) :- line(X1, Y, X2, Y).

point(X, Y) :- line(X, Y, X, Y). % line is effectively 1 point.
point(X, Y) :-
    vertical_line(X, Y1, Y2),
    SY is min(Y1, Y2),
    LY is max(Y1, Y2),
    between(SY, LY, Y).
point(X, Y) :-
    horizontal_line(X1, X2, Y),
    SX is min(X1, X2),
    LX is max(X1, X2),
    between(SX, LX, X).
    
max_y(YOut) :-
    findall(Y, point(_, Y), Ys),
    list_max(Ys, YOut).
    
% Helpers
no_point(X, Y) :- \+ point(X, Y).

list_max([L|Ls], Max) :- foldl(num_num_max, Ls, L, Max).
num_num_max(X, Y, Max) :- Max is max(X, Y).
    
% Sand logic
handle_sand(_, Y, IsInVoid) :-
    max_y(MaxY),
    Y >= MaxY,
    IsInVoid = true.

handle_sand(X, Y, IsInVoid) :-
    Below is Y + 1,
    Left is X - 1,
    Right is X + 1,
    (
        no_point(X, Below) -> handle_sand(X, Below, IsInVoidRes);
        no_point(Left, Below) -> handle_sand(Left, Below, IsInVoidRes);
        no_point(Right, Below) -> handle_sand(Right, Below, IsInVoidRes);
        assertz(point(X, Y)), % Register the sand as a point
        IsInVoidRes = false
    ),
    IsInVoid = IsInVoidRes.
    
pour(I) :-
    NextI is I + 1,
    (
        (handle_sand(500, 0, IsInVoid), IsInVoid)
            -> format('Part 1: ~d ~n', [I]);
        pour(NextI)
    ).

main() :-
    pour(0).
