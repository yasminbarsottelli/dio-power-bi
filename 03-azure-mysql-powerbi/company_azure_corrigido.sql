-- =====================================================================
-- Banco Company (Desafio DIO - Power BI + MySQL na Azure)
-- Versão corrigida: schema + dados em UM arquivo, testada no MySQL 8.0
--
-- O que foi corrigido em relação aos scripts originais:
--  1) Nome do schema: o script de tabelas criava "azure_company", mas o de
--     inserção usava "company_constraints". Agora tudo usa azure_company.
--  2) "alter table ... drop <fk>" virou "drop foreign key" (o MySQL
--     interpretava como DROP COLUMN e dava erro 1091). Como as FKs agora
--     já nascem com o nome e as opções certas, nem precisa de drop/add.
--  3) "drop table dependent" sem a tabela existir dava erro 1051.
--  4) Inserts de employee fora de ordem: o MySQL checa a FK linha a linha,
--     então o gerente (Super_ssn) precisa ser inserido ANTES do subordinado.
--  5) Removidas as consultas com aspas curvas e a tabela "DEPARTMENT"
--     (que não existe), que davam erro de sintaxe.
-- =====================================================================

create schema if not exists azure_company;
use azure_company;

-- Limpa tudo se você precisar rodar o script de novo (ordem: filhos -> pais)
drop table if exists works_on;
drop table if exists dependent;
drop table if exists project;
drop table if exists dept_locations;
drop table if exists departament;
drop table if exists employee;

-- ---------------------------------------------------------------------
-- Tabelas
-- ---------------------------------------------------------------------
create table employee(
    Fname varchar(15) not null,
    Minit char,
    Lname varchar(15) not null,
    Ssn char(9) not null,
    Bdate date,
    Address varchar(30),
    Sex char,
    Salary decimal(10,2),
    Super_ssn char(9),
    Dno int not null default 1,
    constraint chk_salary_employee check (Salary > 2000.0),
    constraint pk_employee primary key (Ssn),
    constraint fk_employee foreign key (Super_ssn) references employee(Ssn)
        on delete set null
        on update cascade
);

create table departament(
    Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9) not null,
    Mgr_start_date date,
    Dept_create_date date,
    constraint chk_date_dept check (Dept_create_date < Mgr_start_date),
    constraint pk_dept primary key (Dnumber),
    constraint unique_name_dept unique (Dname),
    constraint fk_dept foreign key (Mgr_ssn) references employee(Ssn)
        on update cascade
);

create table dept_locations(
    Dnumber int not null,
    Dlocation varchar(15) not null,
    constraint pk_dept_locations primary key (Dnumber, Dlocation),
    constraint fk_dept_locations foreign key (Dnumber) references departament(Dnumber)
        on delete cascade
        on update cascade
);

create table project(
    Pname varchar(15) not null,
    Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    primary key (Pnumber),
    constraint unique_project unique (Pname),
    constraint fk_project foreign key (Dnum) references departament(Dnumber)
);

create table works_on(
    Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    constraint fk_employee_works_on foreign key (Essn) references employee(Ssn),
    constraint fk_project_works_on foreign key (Pno) references project(Pnumber)
);

create table dependent(
    Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char,
    Bdate date,
    Relationship varchar(8),
    primary key (Essn, Dependent_name),
    constraint fk_dependent foreign key (Essn) references employee(Ssn)
);

-- ---------------------------------------------------------------------
-- Dados (mesmos valores do script original, só reordenados)
-- Ordem em employee: James Borg (sem gerente) -> quem responde a ele ->
-- quem responde a esses.
-- ---------------------------------------------------------------------
insert into employee values
    ('James',    'E', 'Borg',    '888665555', '1937-11-10', '450-Stone-Houston-TX',       'M', 55000, NULL,        1),
    ('Franklin', 'T', 'Wong',    '333445555', '1955-12-08', '638-Voss-Houston-TX',        'M', 40000, '888665555', 5),
    ('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX',      'F', 43000, '888665555', 4),
    ('John',     'B', 'Smith',   '123456789', '1965-01-09', '731-Fondren-Houston-TX',     'M', 30000, '333445555', 5),
    ('Ramesh',   'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX',     'M', 38000, '333445555', 5),
    ('Joyce',    'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX',       'F', 25000, '333445555', 5),
    ('Alicia',   'J', 'Zelaya',  '999887777', '1968-01-19', '3321-Castle-Spring-TX',      'F', 25000, '987654321', 4),
    ('Ahmad',    'V', 'Jabbar',  '987987987', '1969-03-29', '980-Dallas-Houston-TX',      'M', 25000, '987654321', 4);

insert into departament values
    ('Research',       5, '333445555', '1988-05-22', '1986-05-22'),
    ('Administration', 4, '987654321', '1995-01-01', '1994-01-01'),
    ('Headquarters',   1, '888665555', '1981-06-19', '1980-06-19');

insert into dept_locations values
    (1, 'Houston'),
    (4, 'Stafford'),
    (5, 'Bellaire'),
    (5, 'Sugarland'),
    (5, 'Houston');

insert into project values
    ('ProductX',        1,  'Bellaire',  5),
    ('ProductY',        2,  'Sugarland', 5),
    ('ProductZ',        3,  'Houston',   5),
    ('Computerization', 10, 'Stafford',  4),
    ('Reorganization',  20, 'Houston',   1),
    ('Newbenefits',     30, 'Stafford',  4);

insert into works_on values
    ('123456789', 1,  32.5),
    ('123456789', 2,  7.5),
    ('666884444', 3,  40.0),
    ('453453453', 1,  20.0),
    ('453453453', 2,  20.0),
    ('333445555', 2,  10.0),
    ('333445555', 3,  10.0),
    ('333445555', 10, 10.0),
    ('333445555', 20, 10.0),
    ('999887777', 30, 30.0),
    ('999887777', 10, 10.0),
    ('987987987', 10, 35.0),
    ('987987987', 30, 5.0),
    ('987654321', 30, 20.0),
    ('987654321', 20, 15.0),
    ('888665555', 20, 0.0);

insert into dependent values
    ('333445555', 'Alice',     'F', '1986-04-05', 'Daughter'),
    ('333445555', 'Theodore',  'M', '1983-10-25', 'Son'),
    ('333445555', 'Joy',       'F', '1958-05-03', 'Spouse'),
    ('987654321', 'Abner',     'M', '1942-02-28', 'Spouse'),
    ('123456789', 'Michael',   'M', '1988-01-04', 'Son'),
    ('123456789', 'Alice',     'F', '1988-12-30', 'Daughter'),
    ('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

-- ---------------------------------------------------------------------
-- Conferência rápida (deve dar: 8 employees, 3 departamentos, 5 locais,
-- 6 projetos, 16 registros em works_on, 7 dependentes)
-- ---------------------------------------------------------------------
select 'employee' as tabela, count(*) as linhas from employee
union all select 'departament', count(*) from departament
union all select 'dept_locations', count(*) from dept_locations
union all select 'project', count(*) from project
union all select 'works_on', count(*) from works_on
union all select 'dependent', count(*) from dependent;
