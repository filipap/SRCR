%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de Conhecimento com informacao genealogica.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: mais definicoes iniciais

:- op(900,xfy,'::').
:- dynamic utente/4.
:- dynamic servico/4.
:- dynamic consulta/5.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Declaracoes

%	utente: #IdUt, Nome, Idade, Cidade ↝ {V,F}
utente(0,joao,19,porto).
utente(1,maria,45,viana).
utente(2,pedro,56,lisboa).
utente(3,jose,67,covilha).
utente(4,albertina,23,viseu).
utente(5,joao,21,viana).

%	servico: #IdServ, Descricao, Instituicao, Cidade ↝ {V,F}
servico(0, 'consulta medicina interna', 'Hospital Particular de Viana', viana).
servico(1, 'consulta medicina dentaria', 'Hospital Particular de Braga', braga).
servico(2, 'consulta dermatologia', 'Hospital Lusiadas', lisboa).
servico(3, 'consulta oftalmologia', 'Hospital de Santo Antonio', porto).
servico(4, 'Consulta de Otorrinolaringologia', 'Hospital Particular de Viana', viana).
servico(5, 'Consulta de Otorrinolaringologia', 'Centro Hospitalar de Viana', viana).

%	consulta: #IdCons, Data, #IdUt, #IdServ, Custo ↝ {V,F}
consulta(0, 2012, 0, 0, 10).
consulta(1, 2014, 0, 0, 12).
consulta(2, 2012, 2, 2, 13).
consulta(3, 2019, 0, 3, 20).
consulta(4, 2019, 4, 0, 12).

consulta(5, 2019, 1, 1, 12).
consulta(6, 2019, 1, 1, 12).
consulta(7, 2019, 2, 2, 12).
consulta(8, 2019, 3, 3, 12).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% I - Registar utentes, servicos e consultas
% II - Remover utentes, servicos e consultas

%%  PREDICADOS AUXILIARES
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado comprimento: ListaSolucoes,Valor -> {V,F}

comprimento([],0).
comprimento([Head],1).
comprimento([Head|Tail],G):-
	comprimento(Tail,T),
	G is T+1.

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


%%  INVARIANTES ESTRUTURAIS

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural: nao permitir a adicao de utentes com o mesmo id na BD

+utente(Id,_,_,_) :: (solucoes(Id,(utente(Id,_,_,_)),S),
                  				 comprimento( S,N ),
                  				 N==1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural: nao permitir a adicao de consultas com o mesmo id na BD

+consulta( Id,_,_,_,_ ) :: (solucoes(Id,(consulta( Id,_,_,_,_ )),S ),
                  						 comprimento( S,N ),
				  						 N == 1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural: nao permitir a adicao de servicos com o mesmo id na BD

+servico( Id,_,_,_ ) :: (solucoes(I,(servico( Id,_,_,_ )),S ),
                  						comprimento( S,N ),
				  						N == 1
				  						).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural: nao remover consultas que nao estejam na BD

-consulta(Id,_,_,_,_) :: (solucoes( (Id,_,_,_,_),(consulta(Id,_,_,_,_)),S ),
                  comprimento( S,N ),
				  N == 0).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural: nao remover utentes que nao estejam na BD

-utente( Id,_,_,_ ) :: (
				  solucoes((Id,_,_,_),(utente(Id,_,_,_)),S),
                  comprimento( S,N ),
				  N == 0
				  ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Estrutural: nao remover servicos que nao estejam na BD

-servico( Id,_,_,_ ) :: (solucoes( (Id,_,_,_),(servico( Id,_,_,_ )),S ),
                  comprimento( S,N ),
				  N == 0).



%%   INVARIANTES REFERENCIAIS

%%%%  UTENTE

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: os ids e as idades sao inteiros

+utente(Id,_,_,_) :: (
	integer(Id)
).

+utente(_,_,Id,_) :: (
	integer(Id)
).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao remover utentes que tenham consultas com o id do 
% utente associado

-utente( Id,_,_,_ ) :: (
				  solucoes( Id,(consulta(_,_,Id,_,_)),S ),
                  comprimento( S,N ),
				  N == 0).

%%%%  CONSULTAS

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: os ids sao inteiros

+consulta( Id,_,_,_,_ ) :: (
	integer(Id)
).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao admitir consultas que nao tenham um servico e um utente incorporado na BD

+consulta( _,_,IdUt,IdSer,_ ) :: (
								 utente(IdUt,_,_,_),
								 servico(IdSer,_,_,_)
								 ).


%%%% SERVICOS

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: os ids sao inteiros

+servico(Id,_,_,_) :: (
	integer(Id)
	).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao admitir varios servicos iguais no mesmo hospital

+servico(_,D,Instituicao,_) :: (solucoes( (D,Instituicao),(servico(_,D,Instituicao,_)),S ),
                  comprimento( S,N ),
                  N==1
				  ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao remover servicos que tenham consultas com o id do 
% servico associado

-servico( Id,_,_,_ ) :: (
				  solucoes( (Id),(consulta(_,_,_,Id,_)),S ),
                  comprimento( S,N ),
				  N == 0).


%%  PREDICADOS PRINCIPAIS
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a evolucao do conhecimento

evolucao( Termo ) :-
		solucoes(Invariante,+Termo::Invariante,Lista),
		insercao(Termo),
		teste(Lista).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a involucao do conhecimento

involucao( Termo ) :-
		Termo,
		solucoes(Invariante,-Termo::Invariante,Lista),
		remocao(Termo),
		teste(Lista).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% III -  Identificar as instituicoes prestadoras de servicos;

pertence(H,[H|T]).
pertence(X,[H|T]) :-
	X \= H,
	pertence(X,T).

elimina(_,[],[]).
elimina(X,[X|T],R):- elimina(X,T,R).
elimina(X,[H|T],[H|R]) :- elimina(X,T,R).

remove_duplicates([],[]).
remove_duplicates([H|T], [H|R]) :- 
   								 elimina(H,T,R1),
   								 remove_duplicates(R1,R).

prestaservico(H) :- solucoes(Instituicao,servico(_,_,Instituicao,_),X),
					remove_duplicates(X,H).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IV -  Identificar utentes/serviços/consultas por critérios de seleção;

%% para os utentes

listUtentes(id,Id,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

listUtentes(nome,Nome,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

listUtentes(idade,Idade,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

listUtentes(cidade,Cidade,LS) :- solucoes((Id,Nome,Idade,Cidade),(utente(Id,Nome,Idade,Cidade)),LS).

%% para os servicos

listServicos(id,Id,LS) :- solucoes((Id,Descricao,Instituicao,Cidade),servico(Id,Descricao,Instituicao,Cidade),LS).

listServicos(descricao,Descricao,LS) :- solucoes((Id,Descricao,Instituicao,Cidade),servico(Id,Descricao,Instituicao,Cidade),LS).

listServicos(instituicao,Instituicao,LS) :- solucoes((Id,Descricao,Instituicao,Cidade),servico(Id,Descricao,Instituicao,Cidade),LS).

listServicos(cidade,Cidade,LS) :- solucoes((Id,Descricao,Instituicao,Cidade),servico(Id,Descricao,Instituicao,Cidade),LS).

%% para as consultas

listConsultas(id,IdCons,LS) :- solucoes((IdCons,Data,IdUt,IdServ,Custo),(consulta(IdCons,Data,IdUt,IdServ,Custo)),LS).

listConsultas(data,Data,LS) :- solucoes((IdCons,Data,IdUt,IdServ,Custo),(consulta(IdCons,Data,IdUt,IdServ,Custo)),LS).

listConsultas(utente,IdUt,LS) :- solucoes((IdCons,Data,IdUt,IdServ,Custo),consulta(IdCons,Data,IdUt,IdServ,Custo),LS).

listConsultas(servico,IdServ,LS) :- solucoes((IdCons,Data,IdUt,IdServ,Custo),consulta(IdCons,Data,IdUt,IdServ,Custo),LS).

listConsultas(custo,Custo,LS) :- solucoes((IdCons,Data,IdUt,IdServ,Custo),consulta(IdCons,Data,IdUt,IdServ,Custo),LS).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% V - Identificar servicos prestados por instituicao/cidade/datas/custo

concat([],L,L).
concat([X|T1],L2,[X|T2]):-concat(T1,L2,T2).

servicos([],[]).
servicos([H],L):- listServicos(id,H,L).
servicos([H|T],LS) :- listServicos(id,H,X),
					  servicos(T,L1),
					  concat(X,L1,LS).

servicosPrestados(custo,Custo,LS) :- solucoes(IdServ,consulta(IdCons,Data,IdUt,IdServ,Custo),X),
									 servicos(X,XS),
									 remove_duplicates(XS,LS).
								
servicosPrestados(instituicao,Instituicao,LS) :- listServicos(instituicao,Instituicao,LS).

servicosPrestados(cidade,Cidade,LS) :- listServicos(cidade,Cidade,LS).

servicosPrestados(data,Data,LS) :- solucoes(IdServ,consulta(IdCons,Data,IdUt,IdServ,Custo),X),
								   servicos(X,XS),
								   remove_duplicates(XS,LS).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% VI -  Identificar os utentes de um servico/instituicao;

utentes([],[]).
utentes([H],L):- listUtentes(id,H,L).
utentes([H|T],LS) :- listUtentes(id,H,X),
					  utentes(T,L1),
					  concat(X,L1,LS).

identificautentes(servico,Ser,Y) :-
						solucoes(Uti,consulta(ID,Data,Uti,Ser,Custo),X),
						utentes(X,XS),
						remove_duplicates(XS,Y).

identificautentes(instituicao,Ins,Y) :-
									solucoes(Uti,
										(consulta(IDconsulta,Data,Uti,Ser,Custo),
										servico(Ser,Desc,Ins,Cidade)),
										X),
									utentes(X,XS),
									remove_duplicates(XS,Y).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% VII - Servicos realizados por utente/instituicao/Cidade

servicosRealizados(utente,IdUt,Result) :- solucoes(IdServ,consulta(_,_,IdUt,IdServ,_),L),
										  servicos(L,L1), 
										  remove_duplicates(L1,Result).
servicosRealizados(instituicao,Instituicao,Result) :- solucoes(IdServ,(consulta(_,_,_,IdServ,_),servico(IdServ,_,Instituicao,_)),L), 
													  servicos(L,L1),
													  remove_duplicates(L1,Result).
servicosRealizados(cidade,Cidade,Result) :- solucoes(IdServ,(consulta(_,_,_,IdServ,_),servico(IdServ,_,_,Cidade)),L), 
											servicos(L,L1),
											remove_duplicates(L1,Result).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% VIII - Calcular o custo total dos cuidados de saude por utente/servico/instituicao/data.

somaCusto([], 0).

somaCusto([(_,_,_,_,C) | T], R) :- somaCusto(T, RR), 
								   R is RR+C.

custoSaude(utente,Utente,C) :- solucoes((Id,Data,Utente,Servico,Custo),consulta(Id,Data,Utente,Servico,Custo),R), 
							   somaCusto(R, C).

custoSaude(servico,Servico,C) :- solucoes((Id,Data,Utente,Servico,Custo),consulta(Id,Data,Utente,Servico,Custo),R), 
								 somaCusto(R, C).

custoSaude(instituicao,Instituicao,C) :- solucoes((Id,Data,Utente,Servico,Custo),consulta(Id,Data,Utente,Servico,Custo),R), 
										 somaCusto(R, C).

custoSaude(data,Data,C) :- solucoes((Id,Data,InstiUtentetuicao,Servico,Custo),consulta(Id,Data,Utente,Servico,Custo),R), 
						   somaCusto(R, C).


% FUNCIONALIDADES ADICIONAIS
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% IX - Instituicoes de uma dada cidade

listInstituicoesCidade(Cidade,LS):- 
					solucoes(Instituicao,servico(_,_,Instituicao,Cidade),X),
					remove_duplicates(X,LS).

		


