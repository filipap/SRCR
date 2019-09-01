%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Base de Conhecimento com informação necessária 

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

:- op(900,xfy,'::').
:- op(995, xfy, '&&'). % conjuncao de respostas
:- op(996, xfy, 'or'). % disjuncao de respostas 
:- dynamic '-'/1.
:- dynamic utente/4.
:- dynamic prestador/4.
:- dynamic cuidado/5.
:- dynamic excecao/1.
:- include(factos).
:- include(auxiliares).

% SISTEMA DE INFERÊNCIA

% ----------------------------------------------------------------------
% Extensao do meta-predicado nao: Questao -> {V,F}
nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado si: Questao,Resposta -> {V,F}
%                            Resposta = { verdadeiro,falso,desconhecido }

si( Questao,verdadeiro ) :-
    Questao.
si( Questao,falso ) :-
    -Questao.  
si( Questao,desconhecido ) :-
    nao( Questao ),
    nao( -Questao ).

%Extensão do predicado conjuncao: Valor,Valor,Resposta -> {V,F}

conjuncao(V1,V2,falso) :- V1 == falso; V2 == falso.
conjuncao(verdadeiro,verdadeiro,verdadeiro).
conjuncao(verdadeiro,desconhecido,desconhecido).
conjuncao(desconhecido,V,desconhecido) :- V == desconhecido; V == verdadeiro.

%Extensão do predicado disjuncao: Valor,Valor,Resposta -> {V,F}

disjuncao(V1,V2,verdadeiro) :- V1 == verdadeiro; V2 = verdadeiro.
disjuncao(falso,falso,falso).
disjuncao(falso,desconhecido,desconhecido).
disjuncao(desconhecido,V,desconhecido) :- V == desconhecido; V == falso.

%Extensão do meta-predicado siList: Questions,Answers -> {V,F}

siList([],[]).
siList([Q|T],[A|R]) :- si(Q,A), siList(T,R).

%Extensão do meta-predicado siComp: composicao_questoes,Resposta -> {V,F}

siComp(Q1 && CQ, R) :- si(Q1,R1), siComp(CQ,R2), conjuncao(R1,R2,R).
siComp(Q1 or CQ, R) :- si(Q1,R1), siComp(CQ,R2), disjuncao(R1,R2,R).
siComp(Q1, R) :- si(Q1,R).

% ------------------------------------------------------
% -------------- Conhecimento Negativo ---------------
% ------------------------------------------------------

-utente(Idu,N,Idd,M) :- nao(utente(Idu,N,Idd,M)), 
                        nao(excecao(utente(Idu,N,Idd,M))).

-prestador(Idp,Nome,Esp,Inst) :- nao(prestador(Idp,Nome,Esp,Inst)), 
                                 nao(excecao(prestador(Idp,Nome,Esp,Inst))).

-cuidado(Data,Idu,Idp,Prio,Desc,Custo) :- nao(cuidado(Data,Idu,Idp,Prio,Desc,Custo)), 
                                          nao(excecao(cuidado(Data,Idu,Idp,Prio,Desc,Custo))).


% --------------------------------------s----------------
% ---------- Invariantes de inserção -----------
% ------------------------------------------------------

% ----------------------------------------------------------------------
% Invariantes de Conhecimento Positivo:  nao permitir a insercao de conhecimento repetido
+utente(Id,_,_,_) :: (solucoes(Id,(utente(Id,_,_,_)),S),
                  				 comprimento( S,N ),
                  				 N==1).

+prestador(Id,_,_,_) :: (solucoes(Id,(prestador(Id,_,_,_)),S),
                  				 comprimento( S,N ),
                  				 N==1).

+cuidado(Data, IdU,IdP, Descricao,Custo) :: (solucoes( ( Data, IdU,IdP, Descricao,Custo), cuidado( Data, IdU,IdP, Descricao,Custo), S ),
                                            comprimento( S,N ),
				                            N==1).

+data(Id,Ano,Mes,Dia) :: ( solucoes(Id,data(Id,Ano,Mes,Dia),S),
                           comprimento(S,1)).

%---------------------------------------------------------------------
% Invariantes de Conhecimento Negativo:  nao permitir a insercao de conhecimento repetido

+(-utente( Id,_,_,_ )) :: (solucoes(Id,(-utente( Id,_,_,_ )),S),
                  				 comprimento( S,N ),
                  				 N==1).

+(-prestador( Id,_,_,_ )) :: (solucoes(Id,(-prestador( Id,_,_,_ )),S),
                  				 comprimento( S,N ),
                  				 N==1).

+(-cuidado(Data,Idu,Idp,Descricao,Custo)) :: ( solucoes( (Data,Idu,Idp,Descricao,Custo), (-cuidado(Data,Idu,Idp,Descricao,Custo)), S ),
                            comprimento( S, N ),
                            N == 1 ).


% ----------------------------------------------------------------------
% Não permitir a inserção de conhecimento contraditório (com neg)
+prestador( Id,Nome,Especialidade,Instituicao) :: ( solucoes( (Id), (-prestador( Id,Nome,Especialidade,Instituicao)), S ),
                            comprimento( S, N ),
                            N == 0 ).

+utente( Id,Nome,Idade,Morada ) :: ( solucoes( (Id), (-utente( Id,Nome,Idade,Morada )), S ),
                            comprimento( S, N ),
                            N == 0 ).

+cuidado(Data,Idu,Idp,Descricao,Custo ) :: ( solucoes( ( Data,Idu,Idp,Descricao,Custo), (-cuidado( Data,Idu,Idp,Descricao,Custo)), S ),
                            comprimento( S, N ),
                            N == 0 ).

%--------------------------------------------------------
% Não permitir a inserção de conhecimento contraditório 
+(-prestador( Id,Nome,Especialidade,Instituicao)) :: ( solucoes( (Id), prestador( Id,Nome,Especialidade,Instituicao), S ),
                            comprimento( S, N ),
                            N == 0 ).

+(-utente( Id,Nome,Idade,Morada )) :: ( solucoes( (Id), utente( Id,Nome,Idade,Morada ), S ),
                            comprimento( S, N ),
                            N == 0 ).

+(-cuidado(Data,Idu,Idp,Descricao,Custo )) :: ( solucoes( (Data,Idu,Idp,Descricao,Custo ), cuidado(Data,Idu,Idp,Descricao,Custo ), S ),
                            comprimento( S, N ),
                            N == 0 ).

                        
% -------------------------------------------------------
% Invariante Referencial:  os ids sao inteiros

+utente(Id,_,_,_) :: (
    integer(Id)
).

+prestador(Id,_,_,_) :: (
    integer(Id)
).

+data(Id,_,_,_) :: (
    integer(Id)  
).

% Invariante Referencial:  a idade é um inteiro
+utente(_,_,Id,_) :: (
    integer(Id)
).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariante Referencial: nao admitir cuidados que nao tenham um prestador e um utente incorporado na BD

+cuidado( _,IdUt,IdSer,_,_ ) :: (
        utente(IdUt,_,_,_),
        prestador(IdP,_,_,_)
).

% ------------------------------------------------------
% ---------- Invariantes de remoção --------------------
% ------------------------------------------------------

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Invariantes Estruturais: nao remover utentes/prestadores/cuidados que nao estejam na BD
-utente( Id,Nome,Idade,Morada ) :: (
        solucoes((Id,Nome,Idade,Morada),(utente(Id,Nome,Idade,Morada)),S),
        comprimento( S,N ),
        N == 0
).


-prestador( Id,Nome,Especialidade,Instituicao) :: (
        solucoes((Id,Nome,Especialidade,Instituicao),(prestador(Id,Nome,Especialidade,Instituicao)),S),
        comprimento( S,N ),
        N == 0
).


-cuidado(Data,Idu,Idp,Descricao,Custo) :: (
        solucoes((Data,Idu,Idp,Descricao,Custo),(cuidado(Data,Idu,Idp,Descricao,Custo)),S),
        comprimento( S,N ),
        N == 0
).

-data(Id,Ano,Mes,Dia) :: (solucoes((Id,Ano,Mes,Dia),data(Id,Ano,Mes,Dia),L),
                           comprimento(L,0)).

% -------------------------------------------------------
% Invariante Referencial:  não permitir a remoção de utentes/prestadores que têm um cuidado associado
-utente(IdUt,_,_,_) :: (solucoes( (IdUt),(cuidado(_,IdUt,_,_,_)),S ),
                                  comprimento( S,N ),
				                  N==0).

-prestador(IdPrest,Nome,Especialidade,Local) :: (solucoes( (IdPrest), cuidado(_,_,IdPrest,_,_),S ),
                                                comprimento( S,N ),
				                                N==0).


% ---------------------------------------------------------
%  --------------- Conhecimento Incerto -------------------
% ---------------------------------------------------------
% um valor nulo do tipo desconhecido e não, necessariamente, de um conjunto determinado de valores.
% exemplos
% nao existe na base de conhecimento a morada do joao, contudo ela existe
excecao(utente(Idu,_,Idd,Morada)) :- utente(Idu,xpto1,Idd,Morada).
excecao(utente(Idu,N,_,Morada)) :- utente(Idu,N,xpto2,Morada).
excecao(utente(Idu,N,Idd,_)) :- utente(Idu,N,Idd,xpto3).

excecao(prestador(Idu,_,Idd,Instituicao)) :- prestador(Idu,xpto4,Idd,Instituicao).
excecao(prestador(Idu,Nome,_,Instituicao)) :- prestador(Idu,Nome,xpto5,Instituicao).
excecao(prestador(Idu,Nome,Idd,_)) :- prestador(Idu,Nome,Idd,xpto6).

% ------------------------------------------------------
% -------------- Conhecimento Impreciso ----------------
% ------------------------------------------------------

% a joana tem 20 ou 21 anos
excecao(utente(100,joana,20,braga)).
excecao(utente(100,joana,21,braga)).

% o dr paulo Especializou-se em cardiologia ou pediatria
excecao(prestador(100,paulo,cardiologia,sao_joao)).
excecao(prestador(100,paulo,pediatria,sao_joao)).

% ------------------------------------------------------
% -------------- Conhecimento Interdito ---------------
% ------------------------------------------------------

excecao(utente(Id,_,Idade,Local)):- utente(Id,xptoNome,Idade,Local).
excecao(utente(Id,Nome,Idade,_)):- utente(Id,Nome,Idade,xptoLocal).
excecao(prestador(Id,Nome,Especialidade,_)):- prestador(Id,Nome,Especialidade,xptoMorada).
excecao(cuidado(_,IDut,Idp,Descricao,Custo)) :- cuidado(xptoData,IDut,Idp,Descricao,Custo).
excecao(cuidado(Data,IDut,Idp,Descricao,_))  :- cuidado(Data,IDut,Idp,Descricao,xptoCusto).
nulo(xptoNome).
nulo(xptoLocal).
nulo(xptoMorada).
nulo(xptoData).
nulo(xptoCusto).

% Invariante nao permitir a adicao de conhecimento interdito
+utente(Id,Nome,Idade,Morada) :: (
        solucoes((Id,Nome,Idade,Morada),(utente(5,Nome,Idade,Morada),nao(nulo(Nome))),LR),
        solucoes((Id,Nome,Idade,Morada),(utente(4,Nome,Idade,Morada),nao(nulo(Morada))),L),
        comprimento(L,0),
        comprimento(LR,0)               
).

+prestador(Id,Nome,Especialidade,Instituicao) :: (
        solucoes(Instituicao,(prestador(3,Nome,Especialidade,Instituicao),nao(nulo(Instituicao))),LR),
        comprimento(LR,0)
).
    
+cuidado(Data,Idu,Idp,Descricao,Custo) :: (
        solucoes(Custo,(cuidado(Data,Idu,Idp,Descricao,Custo),nao(nulo(Custo))),LH),
        solucoes(Data,(cuidado(Data,Idu,Idp,Descricao,Custo),nao(nulo(Data))),LS),
        comprimento(LH,0),
        comprimento(LS,0)
).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a evolucao do conhecimento

%Extensão do predicado tratamento_imprecisos que trata de tornar o conhecimento impreciso em perfeito

tratamento_imprecisos(utente(ID,N,I,M)) :- solucoes(Inv, +utente(ID,N,I,M) :: Inv, S),
                                           excecao(utente(ID,N,I,M)),
                                           insercao(utente(ID,N,I,M)),
			                   teste(S),
                                           removeImpreciso(utente(ID,_,_,_)).

tratamento_imprecisos(prestador(ID,N,E,IDi)) :- solucoes(Inv, +prestador(ID,N,E,IDi) :: Inv, S),
			     excecao(prestador(ID,N,E,IDi)),
                             insercao(prestador(ID,N,E,IDi)),
			     teste(S),
                             removeImpreciso(prestador(ID,_,_,_)).


%Extensão do predicado tratamento_incertos que trata de tornar o conhecimento incerto em perfeito
tratamento_incertos(utente(ID,N,I,M)) :- removeIncerto(utente(ID,_,_,_)), 
                             solucoes(Inv, +utente(ID,N,I,M) :: Inv, S),
                             insercao(utente(ID,N,I,M)),
                             teste(S).
                             

tratamento_incertos(prestador(ID,N,E,IDi)) :- removeIncerto(prestador(ID,N,E,IDi)),
                             solucoes(Inv, +prestador(ID,N,E,IDi) :: Inv, S),
                             insercao(prestador(ID,N,E,IDi)),
                             teste(S).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a evolucao do conhecimento imperfeito

evolucao_imprecisos( Termo ) :- 
        tratamento_imprecisos(Termo).

% Extensao do predicado que permite a evolucao do conhecimento imperfeito

evolucao_incertos( Termo ) :- 
        tratamento_incertos(Termo).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que permite a evolucao do conhecimento perfeito
evolucao_perfeitos( Termo ) :- 
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

