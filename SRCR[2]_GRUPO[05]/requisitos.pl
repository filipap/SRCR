:- include(baseConhecimento).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%  Identificar utentes/prestadores/cuidados por critérios de seleção;

%% para os utentes

listUtentes(id,Id,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

listUtentes(nome,Nome,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

listUtentes(idade,Idade,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

listUtentes(cidade,Cidade,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

%% para os prestadores

listPrestadores(id,Id,LS) :- solucoes((Id,Nome,Especialidade,Instituicao),(prestador(Id,Nome,Especialidade,Instituicao)),LS).

listPrestadores(nome,Nome,LS) :- solucoes((Id,Nome,Especialidade,Instituicao),(prestador(Id,Nome,Especialidade,Instituicao)),LS).

listPrestadores(especialidade,Especialidade,LS) :- solucoes((Id,Nome,Especialidade,Instituicao),(prestador(Id,Nome,Especialidade,Instituicao)),LS).

listPrestadores(instituicao,Instituicao,LS) :- solucoes((Id,Nome,Especialidade,Instituicao),(prestador(Id,Nome,Especialidade,Instituicao)),LS).

%% para os cuidados

listCuidados(data,Data,LS) :- solucoes((Data,Idu,Idp,Descricao,Custo),(cuidado(Data,Idu,Idp,Descricao,Custo)),LS).

listCuidados(utente,Idu,LS) :- solucoes((Data,Idu,Idp,Descricao,Custo),(cuidado(Data,Idu,Idp,Descricao,Custo)),LS).

listCuidados(prestador,Idp,LS) :- solucoes((Data,Idu,Idp,Descricao,Custo),cuidado(Data,Idu,Idp,Descricao,Custo),LS).

listCuidados(descricao,Descricao,LS) :- solucoes((Data,Idu,Idp,Descricao,Custo),cuidado(Data,Idu,Idp,Descricao,Custo),LS).

listCuidados(custo,Custo,LS) :- solucoes((Data,Idu,Idp,Descricao,Custo),cuidado(Data,Idu,Idp,Descricao,Custo),LS).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%  instituicoes prestadoras de cuidados;

instituicoes([],[]).
instituicoes([H],L):- solucoes(Instituicao,(prestador(H,Nome,Especialidade,Instituicao)),L).
instituicoes([H|T],LS) :- solucoes(Instituicao,(prestador(H,Nome,Especialidade,Instituicao)),X),
					  instituicoes(T,L1),
					  concat(X,L1,LS).

prestacuidados(H) :- solucoes(Idp,(cuidado(Data,Idu,Idp,Descricao,Custo)),LS), 
                     instituicoes(LS,X),
                     remove_duplicates(X,H).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar cuidados prestados por instituicao/custo

cuidadosPrestados(custo,Custo,LS) :- listCuidados(custo,Custo,XS),
									 remove_duplicates(XS,LS).

cuidados([],[]).
cuidados([H],L):- solucoes((Data,Idu,Idp,Descricao,Custo),(cuidado(Data,Idu,H,Descricao,Custo)),L).
cuidados([H|T],LS) :- solucoes((Data,Idu,Idp,Descricao,Custo),(cuidado(Data,Idu,H,Descricao,Custo)),X),
					  cuidados(T,L1),
					  concat(X,L1,LS).

cuidadosPrestados(instituicao,Instituicao,LS) :- solucoes(Id,(prestador(Id,Nome,Especialidade,Instituicao)),L),
                                                 cuidados(L,L1),
                                                 remove_duplicates(L1,LS).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Identificar os utentes de um prestador/instituicao;

utentes([],[]).
utentes([H],L):- listUtentes(id,H,L).
utentes([H|T],LS) :- listUtentes(id,H,X),
					  utentes(T,L1),
					  concat(X,L1,LS).

identificautentes(prestador,Idp,Y) :-
						solucoes(Idu,(cuidado(Data,Idu,Idp,Descricao,Custo)),X),
						utentes(X,XS),
						remove_duplicates(XS,Y).

identificautentes(instituicao,Instituicao,Y) :-
									solucoes(Idu,
										(prestador(Id,Nome,Especialidade,Instituicao),
                                        cuidado(Data,Idu,Id,Descricao,Custo)),
										X),
									utentes(X,XS),
									remove_duplicates(XS,Y).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Cuidados prestados por prestador/instituicao

cuidadosPrestados(prestador,IdP,Result) :- listCuidados(prestador,IdP,Result).

cuidadosPrestados(instituicao,Instituicao,Result) :- solucoes((Data,Idu,Id,Descricao,Custo),
                                            (prestador(Id,Nome,Especialidade,Instituicao),
                                            cuidado(Data,Idu,Id,Descricao,Custo)),
                                            Result).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Calcular o custo total dos cuidados de saude por utente/data.

somaCusto([], 0).

somaCusto([(_,_,_,_,C)|T], R) :- somaCusto(T, RR), 
								   R is RR+C.

custoSaude(utente,Idu,C) :- solucoes((Data,Idu,Id,Descricao,Custo),cuidado(Data,Idu,Id,Descricao,Custo),R), 
							   somaCusto(R, C).

custoSaude(data,Data,C) :- solucoes((Data,Idu,Id,Descricao,Custo),cuidado(Data,Idu,Id,Descricao,Custo),R), 
						   somaCusto(R, C).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% cuidados de saúde realizados por utente

cuidados_por_utente(Idu,R) :- solucoes((Data,Id,Idp,Descricao,Custo), cuidado(Data,Idu,Idp,Descricao,Custo), R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% todas instituições a que um utente já recorreu

todas_inst(Idu,R) :- solucoes(Instituicao,(prestador(Idp,_,_,Instituicao), cuidado(_,Idu,Idp,_,_)), R1),
					 remove_duplicates(R1,R).

% cuidado mais caro da base de conhecimento/ ou cuidados se houverem mais com o mesmo custo
% cuidado_mais_caro: Resultado -> {V,F}

cuidado_mais_caro(R) :- solucoes(C, cuidado(_,_,_,_,C), L), 
                        maxLista(L,R1), 
                        solucoes((Data,Idu,Idp,Descricao,R1),cuidado(Data,Idu,Idp,Descricao,R1), R).


