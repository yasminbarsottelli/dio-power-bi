# Desafio de Projeto: Integrando Dados com MySQL na Azure e Transformando com Power BI

Projeto da formação **Power BI Analyst** (DIO). Criei uma instância de MySQL na Azure, popular com a base **Company**, conectei o Power BI e fiz as transformações pedidas no Power Query.

O script do banco está em [`company_azure_corrigido.sql`](./company_azure_corrigido.sql) (os scripts originais precisaram de ajustes para rodar no MySQL 8.0).

## Infraestrutura

Servidor **Azure Database for MySQL (Servidor flexível)**, versão 8.0, criado na Azure. Rodei o script pelo Cloud Shell, liberei meu IP no firewall, conectei no MySQL Workbench e depois no Power BI pelo conector de MySQL.

![Servidor na Azure](imagens/01-servidor-azure.jpg)
![Cloud Shell](imagens/02-cloud-shell.jpg)
![Workbench](imagens/03-workbench.jpg)

## Transformações

| Item | O que fiz |
|---|---|
| 1. Cabeçalhos e tipos | Conferi as 6 tabelas. Ssn, Super_ssn, Essn e Mgr_ssn como Texto; chaves de departamento e projeto como Inteiro; datas como Data; Hours como Decimal. |
| 2. Valores monetários | A coluna Salary virou **Número decimal fixo** (precisão fixa, sem erro de arredondamento). |
| 3. Nulos | O único nulo está em Super_ssn (James Borg). **Não removi**: é o chefe, e apagar a linha tiraria o gerente da Headquarters. |
| 4. Colaborador sem gerente | Só o James Borg, que é o gerente da Headquarters. |
| 5. Departamento sem gerente | Nenhum: os 3 departamentos têm Mgr_ssn preenchido. |
| 6. Preencher lacunas | Não há lacuna. Se houvesse, usaria Substituir valores em Mgr_ssn (nulo pelo Ssn do gerente). |
| 7. Horas dos projetos | O James Borg tem 0 hora no projeto 20, a única linha zerada. Mantive o registro. |
| 8. Colunas complexas | Address dividido por delimitador `-` em Número, Rua, Cidade e Estado (da direita para a esquerda, porque há rua composta, como Fire-Oak). |
| 9. Mesclar employee e departament | Mescla com base na employee, ligando Dno a Dnumber, tipo **Externa Esquerda**, para não perder colaboradores sem departamento. |
| 10. Colunas desnecessárias | Removi as colunas que não serão usadas (ver item 16). |
| 11. Colaboradores e gerentes | Auto-mescla da employee (Super_ssn = Ssn), também **Externa Esquerda**, para manter o James Borg, que não tem gerente. |
| 12. Nome e sobrenome | Fname e Lname mesclados na coluna Name. |
| 13. Departamento e localização | Dname e Dlocation mesclados na coluna Store (5 combinações únicas), feito numa cópia da departament (`departament_local`) para não multiplicar as linhas da employee. |
| 14. Mesclar e não atribuir | Veja a explicação abaixo. |
| 15. Colaboradores por gerente | Agrupamento por Manager com contagem de linhas distintas: Franklin Wong 3, James Borg 2, Jennifer Wallace 2, sem gerente 1. |
| 16. Colunas desnecessárias | Na employee mantive Name, Ssn, Sex, Salary, Dno, Dname, Manager, Address_City e Address_State. |

![Employee](imagens/04-tipos-employee.jpg)
![Address](imagens/05-address.jpg)
![Colaboradores por gerente](imagens/08-agrupamento.jpg)

## Item 14: por que mesclar e não atribuir

A combinação de departamento e localização já forma, sozinha, um identificador único (5 combinações distintas em 5 linhas). Por isso basta **mesclar** as duas colunas: não é preciso atribuir uma chave artificial por fora (uma coluna personalizada ou um índice). O mesclar também substitui as colunas originais, que não serão mais usadas no relatório, e deixa uma chave legível para o modelo estrela do próximo módulo.
