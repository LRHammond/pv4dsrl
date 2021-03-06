subset([], []).
subset([X|A], [X|B]):- subset(A, B).
subset([_|A], B):- subset(A, B).

member(X,[X|_]).
member(X,[_|A]) :- member(X,A).

% actions
action(market(X)) :- people(L), subset(L,X).

% costs
utility(market(X), -C) :- people(L), subset(L,X), length(X,C).

% state
state_fluent(marketed(P)) :- people(L), member(P,L).

% transition
marketed(P,1) :- market(L), member(P,L).
0.5::marketed(P,1) :- market(L), not(member(P,L)), marketed(P,0).

% reward model
0.2::buy_from_marketing(P) :- people(L), member(P,L).
0.3::buy_from_trust(P) :- people(L), member(P,L).

buys(P,1) :- marketed(P,1), buy_from_marketing(P).
buys(P,1) :- trusts(P,P2), buys(P2,1), buy_from_trust(P).

utility(buys(P,1), 5) :- people(L), member(P,L).
