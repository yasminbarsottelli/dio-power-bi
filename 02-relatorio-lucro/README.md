# Relatório Gerencial de Vendas e Lucro

Desafio de projeto do curso **Formação Power BI Analyst** (DIO).
Relatório criado no Power BI Desktop e publicado no Power BI Service, com foco em vendas e lucro da empresa fictícia "Fantasia".

## Arquivos
- `Desafio 3_Relatório Gerencial de Vendas.pbix`: arquivo do Power BI Desktop
- `Desafio 3_Relatório Gerencial de Vendas.pdf`: exportação do relatório

## Página 1: Sales Report
Visão geral de vendas, com cartões e gráficos interativos.

**Cartões:** Total de Vendas, Unidades Vendidas, Descontos, Lucro e Soma de COGS.

**Segmentação de datas:** filtro por período, com botão de limpar filtros.

**Gráficos:**
- Vendas x Mês (gráfico de áreas)
- Vendas x Segmento, com botões para alternar entre barras e pizza
- Vendas x Produto (barras)
- Vendas x País, com botões para alternar entre treemap e mapa

## Página 2: Relatório de Lucro
Análise detalhada do lucro.

- **Cartão de Lucro** com o total geral
- **Botões de ano** (2013 e 2014) para filtrar o período
- **Árvore de decomposição** (Ano > País) para explorar de onde vem o lucro
- **Lucro x Trimestre** em gráfico de cascata
- **Lucro x Produto** em gráfico de radar (visual personalizado)
- **Lucro x Segmento** em treemap, com dica de ferramenta em página mostrando o lucro por trimestre ao passar o mouse
- **Meta de Lucro** em medidor, com meta de 20 milhões (visual personalizado)
- **Previsão de lucro** em gráfico de linhas, com projeção para os próximos meses

## Recursos usados
- Indicadores (bookmarks) e botões para alternar visuais
- Botão de limpar segmentações
- Dica de ferramenta em página (tooltip)
- Previsão na aba Análise
- Visuais personalizados da AppSource (radar e medidor)
- Tema com paleta personalizada em tons de ameixa e magenta
- Publicação no Power BI Service

## Dados
Base de exemplo `financials`, fornecida pelo curso.

## Autora
Yasmin Barsottelli
