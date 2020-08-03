create or replace type conta as object(
  saldo number,
    MEMBER FUNCTION deposito(self in out conta, valor_deposito number) return number,
    member function retirada(self in out conta, valor_retirado number) return number
)not final NOT INSTANTIABLE;

create or replace type conta_corrente under conta(
  
    OVERRIDING MEMBER FUNCTION deposito(self in out conta_corrente, valor_deposito number) return number,
    overriding member function retirada(self in out conta_corrente, valor_retirado number) return number
)not final;

create or replace type conta_poupanca under conta(
  
    OVERRIDING MEMBER FUNCTION deposito(self in out conta_poupanca, valor_deposito number) return number,
    overriding member function retirada(self in out conta_poupanca,valor_retirado number) return number
)not final;

CREATE OR REPLACE TYPE BODY conta_corrente AS
  OVERRIDING MEMBER FUNCTION deposito(self in out conta_corrente, valor_deposito number) RETURN number IS
  BEGIN
    SELF.saldo:=saldo+valor_deposito;
    RETURN saldo;
    END;
  OVERRIDING MEMBER FUNCTION retirada(self in out conta_corrente, valor_retirado number) RETURN number IS
  BEGIN
    SELF.saldo:=saldo-(valor_retirado*1.001);
    RETURN saldo;
    END;
  END;

CREATE OR REPLACE TYPE BODY conta_poupanca AS
  OVERRIDING MEMBER FUNCTION deposito(self in out conta_poupanca, valor_deposito number) RETURN number IS
  BEGIN
    SELF.saldo:=saldo+valor_deposito;
    RETURN saldo;
    END;
  OVERRIDING MEMBER FUNCTION retirada(self in out conta_poupanca, valor_retirado number) RETURN number IS
  BEGIN
    SELF.saldo:=saldo-(valor_retirado*1.0005);
    RETURN saldo;
    END;
  END;
  
declare 
  cc conta_corrente;
  begin
  cc := new conta_corrente(100);
  DBMS_OUTPUT.PUT_LINE(cc.retirada(10));
  end;
  
declare 
  cp conta_poupanca;
  begin
  cp := new conta_poupanca(100);
  DBMS_OUTPUT.PUT_LINE(cp.deposito(10));
  end;
  
  SET SERVEROUTPUT ON;
  
  
  
CREATE OR REPLACE TYPE TELEFONE AS OBJECT
(
numero number
) NOT FINAL;

CREATE OR REPLACE TYPE TELEFONES AS VARRAY(10) OF TELEFONE;

CREATE OR REPLACE TYPE AGENDA AS OBJECT
(
nome varchar(30),
endereco varchar(30),
tels TELEFONES
) NOT FINAL ;

create table tb_agenda of AGENDA;
insert into tb_agenda values ('nome 1', 'rua 1', TELEFONES(TELEFONE(1234567),TELEFONE(98765432), telefone(95959595), telefone(85604949)));
select * from tb_agenda;

CREATE OR REPLACE TYPE filial AS OBJECT (
cnpj number,
localidade varchar(50)
)
CREATE TYPE filiais AS TABLE OF filial;

CREATE TYPE empresa AS OBJECT (
nome varchar(30),
localizacao filiais
)
CREATE TYPE empresas AS TABLE OF empresa;

CREATE TABLE corporacao (
idCorporacao number,
corp empresas
)

NESTED TABLE corp STORE AS tb_empresas
(NESTED TABLE localizacao STORE AS tb_filiais)

 insert into corporacao values(1,empresas(
                            empresa('mikolix',filiais(
                              filial(123,'sorocaba'),
                              filial(546,'jandira'),
                              filial(4859,'itu')
                              )
                        ),
                              empresa('chcuchu',filiais(
                                filial(4859,'sao roque'),
                                filial(789,'boituva'),
                                filial(7895,'capela'),
                                filial(9685,'ourunhos')
                                )
                          )
                        )
                        );
      

select * from corporacao;

create or replace type sala as object(
  numero number,
  capacidade number
);

create table tb_sala of sala;

create or replace type professor as object(
  nome varchar(30),
  titulacao varchar(30)
);

create table tb_professor of professor;

create table tb_disciplina(
 nome varchar(30),
 salas ref sala scope is tb_sala,
 professores ref professor scope is tb_professor
);
  
 Insert into tb_sala values(1,30); 
 
 Insert into tb_professor values('marcelo', 'doutorado');
  
  
Insert into tb_disciplina values ('banco de dados', 
                        (select ref(s)from tb_sala s where s.numero=1),
                        (select ref(p) from tb_professor p where p.nome='marcelo'));
  
select * from tb_disciplina;


create or replace type casa as object(
  endereco varchar(30),
  problema varchar(30)
);

create table tb_casa of casa;  

create or replace type profissional as object(
  nome varchar(30),
  identificacao varchar(30),
  especialidade varchar(30)
);

create table tb_profissional of profissional; 


create table tb_correcao(
 numero_de_os number,
 casas ref casa scope is tb_casa,
 profissionais ref profissional scope is tb_profissional
);

insert into tb_casa values('rua 2', 'hidraulico');
insert into tb_profissional values('joaquim', 'r789',  'hidraulica');
Insert into tb_correcao values (78, 
                        (select ref(c)from tb_casa c where c.endereco='rua 2'),
                        (select ref(p) from tb_profissional p where p.nome='joaquim'));
                        
select * from tb_correcao;

  
