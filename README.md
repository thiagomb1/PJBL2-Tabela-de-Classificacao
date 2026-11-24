# PjBL2 - Tabela de Classificacao

## Sobre o projeto

Este projeto foi feito em Haskell e tem como objetivo montar a tabela de classificacao de um campeonato de futebol a partir dos resultados das partidas.

O programa calcula os pontos e as estatisticas dos times, organiza a classificacao e verifica se existem erros nos dados informados.

## O que o programa faz

- Le e valida os resultados das partidas
- Calcula pontos, vitorias, empates e derrotas
- Calcula gols marcados, sofridos e saldo de gols
- Organiza a tabela seguindo os criterios de desempate
- Mostra a classificacao final e ate uma rodada escolhida
- Calcula a maior goleada e a media de gols
- Identifica erros nas entradas

## Tecnologias utilizadas

- Haskell
- GHC 9.10.3
- Visual Studio Code

## Organizacao dos arquivos

O projeto foi dividido nas seguintes pastas:

- `src`: contem os arquivos do programa
- `tests`: contem os testes das funcoes
- `docs`: contem as explicacoes sobre as decisoes tomadas no projeto

O arquivo `Main.hs` executa o programa, enquanto `Dados.hs` guarda os resultados do campeonato utilizado como exemplo

## Como executar

Abra o terminal na pasta principal do projeto e execute:

`runghc -isrc .\src\Main.hs`

## Como executar os testes

No mesmo terminal, execute:

`runghc -isrc .\tests\Testes.hs`

## Como verificar a compilacao

Para conferir a compilacao do programa:

`ghc -Wall -fno-code -isrc .\src\Main.hs`

Para conferir a compilacao dos testes:

`ghc -Wall -fno-code -isrc .\tests\Testes.hs`

## Divisao do projeto

### Camada 1 - Tipos

Define os tipos utilizados para representar times, partidas, resultados e linhas da tabela

### Camada 2 - Classificacao

Contem as funcoes que calculam os resultados, as estatisticas e a classificacao dos times

### Camada 3 - Leitura

Faz a leitura dos dados, verifica entradas invalidas e prepara a exibicao da tabela

## Campeonato utilizado

Para testar o programa, usamos um campeonato ficticio com 6 times, 5 rodadas e 15 partidas

Os resultados incluem empates, uma vitoria por 3 gols de diferenca e times que terminam empatados em pontos, permitindo verificar os criterios de desempate

## Integrantes
- Thiago Marcos Burtet
- Eduardo dos Santos Granha
- Lucas Tian Le Wu