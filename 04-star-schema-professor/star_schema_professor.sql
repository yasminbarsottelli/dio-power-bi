-- Star Schema: análise de Professores
-- Desafio DIO - Modelagem Dimensional
-- Granularidade: 1 linha = 1 professor ministrando 1 disciplina em 1 curso em 1 semestre letivo
-- Campos marcados com (SUPOSIÇÃO) não existem no diagrama relacional original.

DROP SCHEMA IF EXISTS dw_universidade;
CREATE SCHEMA dw_universidade DEFAULT CHARACTER SET utf8mb4;
USE dw_universidade;

-- ---------------------------------------------------------------
-- DIMENSÕES (cada uma com chave artificial sk_ + id original)
-- ---------------------------------------------------------------

CREATE TABLE d_professor (
  sk_professor INT NOT NULL AUTO_INCREMENT,
  idProfessor  INT NOT NULL,                 -- id original do sistema transacional
  nome         VARCHAR(100) NULL,            -- (SUPOSIÇÃO)
  titulacao    VARCHAR(45)  NULL,            -- (SUPOSIÇÃO) ex: Mestre, Doutor
  PRIMARY KEY (sk_professor)
) ENGINE = InnoDB;

CREATE TABLE d_disciplina (
  sk_disciplina INT NOT NULL AUTO_INCREMENT,
  idDisciplina  INT NOT NULL,                -- id original
  nome          VARCHAR(100) NULL,           -- (SUPOSIÇÃO)
  PRIMARY KEY (sk_disciplina)
) ENGINE = InnoDB;

CREATE TABLE d_curso (
  sk_curso INT NOT NULL AUTO_INCREMENT,
  idCurso  INT NOT NULL,                     -- id original
  nome     VARCHAR(100) NULL,                -- (SUPOSIÇÃO)
  PRIMARY KEY (sk_curso)
) ENGINE = InnoDB;

CREATE TABLE d_departamento (
  sk_departamento INT NOT NULL AUTO_INCREMENT,
  idDepartamento  INT NOT NULL,              -- id original
  Nome            VARCHAR(45) NULL,          -- existe no diagrama original
  Campus          VARCHAR(45) NULL,          -- existe no diagrama original
  PRIMARY KEY (sk_departamento)
) ENGINE = InnoDB;

CREATE TABLE d_data (
  sk_data         INT NOT NULL AUTO_INCREMENT,
  ano             INT NOT NULL,              -- ex: 2025
  semestre        INT NOT NULL,              -- 1 ou 2
  semestre_letivo VARCHAR(6) NOT NULL,       -- ex: 2025.1
  data_inicio     DATE NULL,                 -- (SUPOSIÇÃO)
  data_fim        DATE NULL,                 -- (SUPOSIÇÃO)
  PRIMARY KEY (sk_data)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- FATO
-- ---------------------------------------------------------------

CREATE TABLE f_professor (
  sk_fato_professor  INT NOT NULL AUTO_INCREMENT,
  sk_professor    INT NOT NULL,
  sk_disciplina   INT NOT NULL,
  sk_curso        INT NOT NULL,
  sk_departamento INT NOT NULL,
  sk_data         INT NOT NULL,
  carga_horaria   INT NULL,                  -- (SUPOSIÇÃO) métrica, em horas
  PRIMARY KEY (sk_fato_professor),
  -- garante a granularidade: não repete a mesma combinação
  UNIQUE KEY uq_grao (sk_professor, sk_disciplina, sk_curso, sk_departamento, sk_data),
  CONSTRAINT fk_f_professor
    FOREIGN KEY (sk_professor)    REFERENCES d_professor (sk_professor),
  CONSTRAINT fk_f_disciplina
    FOREIGN KEY (sk_disciplina)   REFERENCES d_disciplina (sk_disciplina),
  CONSTRAINT fk_f_curso
    FOREIGN KEY (sk_curso)        REFERENCES d_curso (sk_curso),
  CONSTRAINT fk_f_departamento
    FOREIGN KEY (sk_departamento) REFERENCES d_departamento (sk_departamento),
  CONSTRAINT fk_f_data
    FOREIGN KEY (sk_data)         REFERENCES d_data (sk_data)
) ENGINE = InnoDB;
