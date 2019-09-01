% utente: IdUt, Nome, Idade, Morada ↝ { 𝕍, 𝔽, 𝔻 }
utente(1,'Ana Martins' ,30,porto).
utente(2,'Beatriz Costa',21,lisboa).
utente(3,'Catarina Furtado',45,lisboa).
utente(4,'Diogo Picarra',27,xptoLocal).
utente(5,xptoNome,34,viana).
utente(6,xpto1,45,braga).
utente(7,marco,xpto2,braga).
utente(8,maria,67,xpto3).

% prestador: IdPrest, Nome, Especialidade, Instituição ↝ { 𝕍, 𝔽, 𝔻 }
prestador(1,'Emanuel Santos',ortopedia,'Hospital Particular de Viana').
prestador(2,'Filipe Ferreira',fisioterapia,'Hospital Lusiadas').
prestador(3,'Guilherme Lima',cardiologia,xptoMorada).
prestador(4,'Helena Gomes',dermatologia,'Hospital Lusiadas').
prestador(5,xpto4,45,'hospital braga').
prestador(6,marco,xpto5,'hospital braganca').
prestador(7,maria,67,xpto6).


% cuidado: Data, IdUt, IdPrest, Descrição, Custo ↝ { 𝕍, 𝔽, 𝔻 }
cuidado(1,1,1,consulta_ortopedia,20 ).
cuidado(2,2,2,massagem,100).
cuidado(3,3,1,consulta_ortopedia,20).
cuidado(4,4,3,eletrocardiograma,50).
cuidado(4,1,4,massagem,100).
cuidado(5,3,2,xptoCusto).
cuidado(xptoData,1,4,medicina_interna,50).

% data: IdData, Ano, Mês, Dia ↝ { 𝕍, 𝔽, 𝔻 }
data(1,2014,1,1).
data(2,2012,1,5).
data(3,2018,2,5).
data(4,2013,2,6).
data(5,2011,2,7).
