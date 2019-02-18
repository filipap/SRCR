%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3 (ficha pratica 01)

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de Conhecimento com informacao genealogica. 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado soma: X,Y -> {V,F}

soma(X,Y,Soma):-
	Soma is X+Y.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado soma3: X,Y,Z -> {V,F}

soma3(X,Y,Z,Soma3):-
	Soma3 is X+Y+Z.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado operacao: OP,X,Y,R(Resultado) -> {V,F}  

adicao(adicao,X,Y,Adicao) :-
	Adicao is X+Y.

subtracao(subtracao,X,Y,Subtracao) :-
	Subtracao is X-Y.

multiplicacao(multiplicacao,X,Y,Multiplicacao) :-
	Multiplicacao is X*Y.

divisao(divisao,X,Y,Divisao) :-
	Y\=0, 						% isto é uma condiçao (uma vez que a divisao por 0 é indeterminada)
	Divisao is X/Y.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado max: X,Y,R(Resultado) -> {V,F}

max(X,Y,X) :- X>Y.
max(X,Y,Y) :- X =< Y.





