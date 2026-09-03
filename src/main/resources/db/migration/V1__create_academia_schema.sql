CREATE TABLE alunos(
  id BIGSERIAL PRIMARY KEY ,
  nome varchar(150) NOT NULL,
  data_nascimento DATE,
  sexo varchar(1) CHECK ( sexo IN ('M', 'F') ),
  telefone varchar(30),
  celular varchar(30),
  email varchar(150),
  observacao TEXT,
  endereco varchar(150),
  numero varchar(20),
  complemento varchar(100),
  bairro varchar(100),
  cidade varchar(100),
  estado varchar(2),
  cep varchar(20),
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP
);

CREATE TABLE modalidades(
    id BIGSERIAL PRIMARY KEY,
    nome  varchar(100) NOT NULL UNIQUE,
    ativa BOOLEAN not null default true
);

CREATE TABLE graduacoes(
  id BIGSERIAL primary key,
  modalidade_id BIGINT NOT NULL references modalidades(id),
  nome varchar(100) NOT NULL,
  UNIQUE (modalidade_id, nome)
);

CREATE TABLE planos(
    id BIGSERIAL primary key,
    modalidade_id BIGINT not null references modalidades(id),
    nome varchar(100) not null,
    valor_mensal numeric(10,2) not null check (valor_mensal >=0),
    ativo BOOLEAN not null default true,
    unique (modalidade_id, nome)
);

CREATE TABLE matriculas(
    id  BIGSERIAL primary key,
    alunos_id BIGINT not null references alunos(id),
    data_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
    dia_vencimento INTEGER NOT NULL CHECK ( dia_vencimento BETWEEN 1 AND 31),
    data_encerramento DATE,
    status varchar(20) NOT NULL DEFAULT 'ATIVA',
    CHECK ( status IN ('ATIVA', 'ENCERRADA', 'CANCELADA') )
);

CREATE TABLE matriculas_modalidades(
  id BIGSERIAL primary key,
  matricula_id BIGINT not null references matriculas(id),
  modalidade_id BIGINT not null references modalidades(id),
  graduacao_id BIGINT not null references graduacoes(id),
  plano_id BIGINT not null references planos(id),
  data_inicio DATE NOT NULL DEFAULT CURRENT_DATE,
  data_fim DATE,
  UNIQUE (matricula_id, modalidade_id)
);

CREATE TABLE faturas_matriculas(
  id BIGSERIAL primary key,
  matricula_id BIGINT not null references matriculas(id),
  data_vencimento date not null,
  valor numeric(10,2) not null check ( valor >=0 ),
  data_pagamento TIMESTAMP,
  data_cancelamento date,
  status varchar(20) not null default 'ABERTA',
  check ( status IN ('ABERTA', 'PAGA', 'CANCELADA', 'VENCIDA') ),
  unique (matricula_id, data_vencimento)
);

CREATE TABLE assiduidade(
  id BIGSERIAL primary key,
  matricula_id BIGINT not null references matriculas(id),
  data_entrada timestamp not null default CURRENT_TIMESTAMP,
  data_saida timestamp
);