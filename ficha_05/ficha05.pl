%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariantes

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:- op( 900,xfy,'::' ). % o operador :: tem de ser definido inicialmente!!! -> nao est?presente no PROLOG 
:- dynamic filho/2.
:- dynamic pai/2.
:- dynamic avo/2. %% dynamic significa que o predicado pode ser alterado ao longo da execu?o do script
%%					 (podem haver incer?es e remo?es)
%% 					 o /2 significa que o predicado recebe 2 argumentos.
:- dynamic neto/2.
:- dynamic idade/2.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado filho: Filho,Pai -> {V,F,D}

filho( joao,jose ).
filho( jose,manuel ).
filho( carlos,jose ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado idade: Filho,Idade -> {V,F,D}

idade( joao,18 ).
idade( jose,50 ).
idade( carlos,23 ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado pai: Pai,Filho -> {V,F}

pai( P,F ) :-
    filho( F,P ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado avo: Avo,Neto -> {V,F}

avo(A,N) :-
	pai(A,P),
	pai(P,N).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado neto: Neto,Avo -> {V,F}

neto(N,A) :- avo(A,N).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado descendente: Descendente,Ascendente -> {V,F}

descendente(D,A) :-
	filho(D,A).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado insercao : Termo -> {V,F}

insercao( Termo ) :- assert( Termo ).

insercao( Termo ) :- retract( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado solucoes: Formato,Relacao,ListaSolucoes -> {V,F}

solucoes(F,R,LS) :- 
			R,assert(tmp(F)),fail.

solucoes(F,R,LS) :- 
			construir([],LS).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado construir: ListaSolucoes,Solucao -> {V,F}

construir(LS,S):-
		retract(tmp(X)),
		construir([X|LS],S).

construir(S,S).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado comprimento: ListaSolucoes,Solucao -> {V,F}

%%solucoes(F,R,LS):-findall(F,R,LS).
comprimento(S,N):-length(S,N).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural:  nao permitir a insercao de conhecimento
%                         repetido

+filho( F,P ) :: (solucoes( (F,P),(filho( F,P )),S ),
                  comprimento( S,N ), 
				  N == 1
                  ).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao admitir mais do que 2 progenitores
%                         para um mesmo individuo

+filho( F,P ) :: (solucoes( (P),(filho( F,P )),S ),
                  comprimento( S,N ), 
				  N =< 2). 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao remover filhos
%                         que nao estejam presentes no registo de idades

-filho( F,P ) :: (solucoes( (F),(idade( F,I )),S ),
                  comprimento( S,N ), 
				  N == 0). 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural (pai): nao permitir a insercao de conhecimento
%                         repetido

+pai( P,F ) :: (solucoes( (P,F),(pai( F,P )),S ),
                  comprimento( S,N ), 
				  N == 1
                ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural (neto): nao permitir a insercao de conhecimento
%                         repetido

+neto( N,A ) :: (solucoes( (N,A),(neto( N,A )),S ),
                  comprimento( S,N ), 
				  N == 1
                ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural (avo): nao permitir a insercao de conhecimento
%                         repetido

+avo( N,A ) :: (solucoes( (N,A),(neto( N,A )),S ),
                  comprimento( S,N ), 
				  N == 1
                ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado teste: Lista -> {V,F}

teste([]).
teste( [R|LR] ) :- 
	R,
	teste(LR).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a evolucao do conhecimento

evolucao( Termo ) :- 
		solucoes(Invariante,+Termo::Invariante,Lista),
		insercao(Termo),
		teste(Lista).




