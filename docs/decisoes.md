# Decisoes de Modelagem e Limitacoes

## 1. Organizacao do projeto

Dividimos o programa em tres camadas para organizar melhor o codigo e facilitar os testes

- **Camada 1 (Tipos.hs):** define os tipos e as funcoes basicas
- **Camada 2 (Classificacao.hs):** faz os calculos da tabela e das estatisticas
- **Camada 3 (Leitura.hs):** le os resultados, verifica erros e formata a tabela

Tambem usamos o arquivo `Dados.hs` para guardar os resultados do campeonato e o `Main.hs` para executar o programa

## 2. Tipos utilizados

Usamos `String` para representar os nomes dos times

O tipo `Resultado` pode ter tres valores: `Vitoria`, `Empate` ou `Derrota`

Para representar as partidas e as linhas da classificacao, usamos `Partida` e `Linha`, com campos nomeados para facilitar o acesso aos dados

## 3. Funcoes utilizadas

Utilizamos funcoes como `map`, `filter` e `foldl'` para trabalhar com as listas de partidas e times

O `map` permite aplicar uma funcao a cada elemento de uma lista, enquanto o `filter` seleciona os elementos que atendem a uma condicao

O `foldl'` foi utilizado para percorrer as partidas e acumular as estatisticas de cada time. Escolhemos essa versao porque ela evita acumular calculos pendentes

## 4. Classificacao dos times

A classificacao segue esta ordem:

1. Maior numero de pontos
2. Maior saldo de gols
3. Maior numero de gols marcados
4. Ordem alfabetica do nome do time

Para organizar a tabela, usamos `comparing` e `Down`, combinando os criterios de desempate

## 5. Uso de Maybe e Either

Usamos `Maybe` nas funcoes que podem nao encontrar um resultado

Por exemplo, quando nao existem partidas, `maiorGoleada` e `mediaGols` retornam `Nothing`

O `Either` foi utilizado para tratar erros de leitura. Quando uma entrada e invalida, o programa retorna `Left` com a informacao do erro, em vez de encerrar a execucao

Tambem utilizamos `readMaybe` para converter numeros e `traverse` para processar as partidas

## 6. Validacao dos dados

O programa verifica alguns problemas que podem aparecer nos resultados:

- Quantidade errada de campos
- Numeros invalidos
- Gols negativos
- Um time jogando contra ele mesmo
- Um time aparecendo mais de uma vez na mesma rodada
- Nome de time vazio
- Numero de rodada invalido

A funcao `todosOsErros` permite encontrar mais de um erro na entrada

## 7. Limitacoes

O programa atende ao campeonato utilizado no trabalho, mas possui algumas limitacoes:

- Diferencia nomes escritos com letras maiusculas e minusculas
- Nao verifica se todas as rodadas possuem a mesma quantidade de partidas
- Permite que os mesmos times se enfrentem em rodadas diferentes
- Os resultados do campeonato ficam definidos no codigo
- A classificacao e exibida no terminal, sem interface grafica
- Na verificacao de times repetidos, considera apenas partidas que foram lidas corretamente

## 8. Testes

Criamos 26 testes para verificar as funcoes das tres camadas do programa

Os testes verificam os resultados das partidas, os calculos da classificacao, os criterios de desempate e o tratamento de entradas invalidas

Tambem testamos casos como campeonato vazio e aproveitamento sem jogos

Todos os 26 testes passaram