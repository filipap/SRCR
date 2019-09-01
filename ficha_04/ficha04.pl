 %--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3 (ficha pratica 03)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Programação em Logica - manipulacao de numeros

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado par : X -> {V,F}

par(X):- X mod 2 =:= 0.	

% Extensao do predicado impar : X -> {V,F}

impar(X):- \+(par(X)).


% Extensao do predicado naturais : X -> {V,F}

naturais(0).

naturais(X):-
	N>0,
	N is X-1,
	naturais(N).

% Extensao do predicado inteiros : X -> {V,F}

inteiros(X):-par(X).
inteiros(X):-impar(X). 