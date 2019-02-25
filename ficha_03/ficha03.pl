%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3 (ficha pratica 03)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programação em Logica - manipulacao de listas

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado pertence : X,L -> {V,F}

pertence(X,[X|Tail]).

pertence(X,[Head|Tail]):-	
	pertence(X,Tail).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado comprimento : L,T -> {V,F}

comprimento([],0).
comprimento([Head],1).
comprimento([Head|Tail],G):-
	comprimento(Tail,T),
	G is T+1.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado diferentes: L,T -> {V,F} que calcula a qts elementos diferentes numa lista

diferentes([],0).
diferentes([A],1).
diferentes([Head|Tail],N):-
	pertence(Head,Tail),
	diferentes(Tail,N).

diferentes([Head|Tail],N):-
	\+ pertence(Head,Tail),
	diferentes(Tail,G),
	N is G+1. 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado apaga1: E,T,A -> {V,F} que apaga o primeiro elemento igual a E da lista

apaga1(A,[A|Tail],Tail).

%-- NOTA: o H nao deve ser apagado no caso de ele nao ser o elemento a eliminar dai o [H|T]

apaga1(A,[Head|Tail],[H|L]):- 
	A \= Head,
	apaga1(A,Tail,L).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado concatena: E,T,NV -> {V,F} que concatena 2 listas

concatena([],B,B).
% concatena(A,[],A). é um caso particular de concatena([H|T],L2,[H|R])
concatena([H|T],L2,[H|R]):-
	concatena(T,L2,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensão do predicado «sublista» que determina se uma lista S é uma sublista de outra lista L

sublista(S,L):-
	concatena(L1,L3,L),
	concatena(S,L2,L3).






