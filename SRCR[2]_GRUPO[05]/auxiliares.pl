

% ------------------------------------------------------
% --------------    Predicados Auxiliares	------------
% ------------------------------------------------------

% ----------------------------------------------------------------------
% Predicado comprimento: Lista, Comprimento -> {V,F}
comprimento([],0).
comprimento([_H],1).
comprimento([_H|T],N) :- comprimento(T,M), N is M+1.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado teste: Lista -> {V,F}

teste([]).
teste( [R|LR] ):-
    R,
	teste(LR).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado insercao : Termo -> {V,F}

insercao( Termo ) :- assert( Termo ).

insercao( Termo ) :- retract( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado remocao : Termo -> {V,F}

remocao( Termo ) :- retract( Termo ).

remocao( Termo ) :- assert( Termo ),!,fail.

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
		!,
		construir([X|LS],S).

construir(S,S).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado concatenar: ListaConcatenar1,ListaConcatenar2,Solucao -> {V,F}
concat([],L,L).
concat([X|T1],L2,[X|T2]):-concat(T1,L2,T2).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado remove_duplicates: Lista1,Lista2 -> {V,F}

elimina(_,[],[]).
elimina(X,[X|T],R):- elimina(X,T,R).
elimina(X,[H|T],[H|R]) :- elimina(X,T,R).

remove_duplicates([],[]).
remove_duplicates([H|T], [H|R]) :- 
									elimina(H,T,R1),
									remove_duplicates(R1,R).

% máximo de uma lista
% maxLista: Lista, Resultado -> {V,F}

maxLista([H],R):- R is H.
maxLista([X|L],R) :- maxLista(L,N), X>N, R is X.
maxLista([X|L],R) :- maxLista(L,N), X=<N, R is N.


% remove conhecimento impreciso da base de conhecimento
removeImpreciso(utente(Id,Nome,Idd,M)) :- solucoes(utente(Id,Nome,Idd,M), (excecao(utente(Id,Nome,Idd,M)), Nome \= xpto1, Idd \= xpto2, M \= xpto3), S),
									   remove_imprecisos(S).
									   
removeImpreciso(prestador(Id,N,E,Idi)) :- solucoes(prestador(Id,N,E,Idi), (excecao(prestador(Id,N,E,Idi)), N \= xpto4, E \= xpto5, Idi \= xpto6), S),
										remove_imprecisos(S).

%Extensão do predicado remove_imprecisos que, dada uma lista de termos, remove a respetiva exceção de conhecimento impreciso

remove_imprecisos([]).
remove_imprecisos([Termo]) :- retract(excecao(Termo)). 
remove_imprecisos([Termo|T]) :- retract(excecao(Termo)), remove_imprecisos(T).


% extesão do predicado que remove todos os elementos de uma lista

removeAllFromLista([]).
removeAllFromLista([H]) :- retract(H).

% remove todo o conhecimento incerto associado a um fato
removeIncerto(utente(ID,_,_,_)) :- solucoes(utente(ID,N,I,M,D), (utente(ID,N,I,M), (N == xpto1; I == xpto2; M == xpto3)), S),
								   removeAllFromLista(S).

removeIncerto(prestador(ID,_,_,_)) :- solucoes(prestador(ID,N,E,IDi), (prestador(ID,N,E,IDi), (N == xpto4; E == xpto5; IDi == xpto6)), S),
									  removeAllFromLista(S).