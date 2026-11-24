
module Main where

import Tipos
import Dados (dadosCampeonato)
import Classificacao
import Leitura

main :: IO ()
main = do


  case lerCampeonato dadosCampeonato of
    Left erro ->
      putStrLn ("Erro ao ler campeonato: " ++ show erro)

    Right partidas -> do
      putStrLn "\n--- CLASSIFICACAO FINAL ---"
      putStrLn (tabelaFormatada (classificacao partidas))

      putStrLn "\n--- CLASSIFICACAO APOS A RODADA 3 ---"
      let partidasParciais = ateRodada 3 partidas
      putStrLn (tabelaFormatada (classificacao partidasParciais))

      putStrLn "\n--- ESTATISTICAS ---"
      putStrLn ("Total de partidas: " ++ show (length partidas))

      putStrLn ("Media de gols por partida: "
        ++ maybe "Indisponivel" show (mediaGols partidas))

      putStrLn ("Maior goleada: "
        ++ maybe "Indisponivel" mostrarPartida (maiorGoleada partidas))

      putStrLn "\n=== TESTE DE ENTRADAS INVALIDAS ==="
      let entradaInvalida = unlines
            [ "1;Coritiba;dois;0;Athletico"
            , "2;Parana;-1;0;Londrina"
            , "3;Operario;1;1;Operario"
            , "4;Maringa;2;0"
            ]

      putStrLn "Erros encontrados:"
      mapM_ (putStrLn . show) (todosOsErros entradaInvalida)

      putStrLn "\n--- FIM DA DEMONSTRACAO ---"

mostrarPartida :: Partida -> String
mostrarPartida partida =
  mandante partida
  ++ " " ++ show (golsMandante partida)
  ++ " x " ++ show (golsVisitante partida)
  ++ " " ++ visitante partida
  ++ " (Rodada " ++ show (rodada partida) ++ ")"
