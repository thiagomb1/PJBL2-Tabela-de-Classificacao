
module Main where

import Tipos
import Dados (dadosCampeonato)
import Classificacao
import Leitura

testar :: (Eq a, Show a) => String -> a -> a -> IO ()
testar nome obtido esperado
  | obtido == esperado = putStrLn ("OK     " ++ nome)
  | otherwise = putStrLn
      ("FALHOU " ++ nome ++
       "\n  Obtido: " ++ show obtido ++
       "\n  Esperado: " ++ show esperado)

partidaExemplo :: Partida
partidaExemplo = Partida 1 "Coritiba" 3 0 "Maringa"

main :: IO ()
main = do
  putStrLn "--- TESTES DA CAMADA 1 ---"

  testar "Resultado do mandante"
    (resultadoPara "Coritiba" partidaExemplo)
    (Just Vitoria)

  testar "Resultado do visitante"
    (resultadoPara "Maringa" partidaExemplo)
    (Just Derrota)

  testar "Time ausente"
    (resultadoPara "Parana" partidaExemplo)
    Nothing

  testar "Resultado de empate"
    (resultadoPara "Athletico" (Partida 1 "Athletico" 1 1 "Londrina"))
    (Just Empate)

  testar "Vitoria do visitante"
    (resultadoPara "Athletico" (Partida 5 "Coritiba" 0 1 "Athletico"))
    (Just Vitoria)

  testar "Times sem repeticao"
    (fmap times (lerCampeonato dadosCampeonato))
    (Right ["Athletico", "Coritiba", "Londrina",
            "Maringa", "Operario", "Parana"])

  putStrLn "\n--- TESTES DA CAMADA 2 ---"

  testar "Aproveitamento de 100%"
    (aproveitamento (Linha "Teste" 1 1 0 0 2 0))
    100.0

  testar "Aproveitamento sem jogos"
    (aproveitamento (Linha "Teste" 0 0 0 0 0 0))
    0.0



  case lerCampeonato dadosCampeonato of
    Left erro -> putStrLn ("FALHOU leitura: " ++ show erro)
    Right partidas -> do
      let tabela = classificacao partidas
          parcial = classificacao (ateRodada 3 partidas)
    
      testar "Classificacao completa do Athletico"
        (take 1 tabela)
        [Linha "Athletico" 5 2 2 1 5 4]

      testar "Pontos da classificacao final"
        (map pontosLinha tabela)
        [8, 7, 6, 6, 4, 4]

      testar "Ordem da classificacao final"
        (map time tabela)
        ["Athletico", "Operario", "Coritiba",
         "Parana", "Londrina", "Maringa"]

      testar "Desempate Coritiba e Parana por saldo"
        (saldo (tabela !! 2) > saldo (tabela !! 3))
        True

      testar "Classificacao apos rodada 3"
        (map time parcial)
        ["Coritiba", "Athletico", "Parana",
         "Operario", "Londrina", "Maringa"]

      testar "Maior goleada"
        (maiorGoleada partidas)
        (Just partidaExemplo)

      testar "Media de gols"
        (mediaGols partidas)
        (Just (28 / 15 :: Double))

  testar "Maior goleada sem partidas"
    (maiorGoleada [])
    Nothing

  testar "Media sem partidas"
    (mediaGols [])
    Nothing

  putStrLn "\n--- TESTES DA CAMADA 3 ---"

  testar "Leitura de campeonato valido"
    (fmap length (lerCampeonato dadosCampeonato))
    (Right 15)

  testar "Campos invalidos"
    (lerPartida 1 "1;A;2;B")
    (Left (CamposInvalidos 1))

  testar "Numero invalido"
    (lerPartida 2 "1;A;dois;0;B")
    (Left (NumeroInvalido 2 "dois"))

  testar "Placar negativo"
    (lerPartida 3 "1;A;-1;0;B")
    (Left (PlacarNegativo 3))

  testar "Mesmo time"
    (lerPartida 4 "1;A;2;0;A")
    (Left (MesmoTime 4))

  testar "Time repetido na rodada"
    (lerCampeonato
      "1;A;2;0;B\n1;A;1;1;C")
    (Left (TimeRepetidoNaRodada 1 "A"))

  testar "Nome vazio"
    (lerPartida 6 "1;;2;0;B")
    (Left (NomeVazio 6))

  testar "Rodada invalida"
    (lerPartida 7 "0;A;2;0;B")
    (Left (RodadaInvalida 7))

  testar "Todos os erros"
    (todosOsErros
      "1;A;dois;0;B\n2;C;-1;0;D\n3;E;1;1;E")
    [ NumeroInvalido 1 "dois"
    , PlacarNegativo 2
    , MesmoTime 3
    ]

  testar "Campeonato vazio"
    (lerCampeonato "")
    (Right [])

  putStrLn "\n--- FIM DOS TESTES ---"
