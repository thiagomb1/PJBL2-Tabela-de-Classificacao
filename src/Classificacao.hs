
module Classificacao
  ( pontos
  , linhaDoTime
  , pontosLinha
  , saldo
  , aproveitamento
  , classificacao
  , ateRodada
  , maiorGoleada
  , mediaGols
  ) where

import Tipos
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))


-- CAMADA 2: CALCULOS DA CLASSIFICACAO

pontos :: Resultado -> Int
pontos Vitoria = 3
pontos Empate  = 1
pontos Derrota = 0

linhaDoTime :: [Partida] -> Time -> Linha
linhaDoTime partidas nome =
  foldl' acumular inicial (filter (participou nome) partidas)
  where
    inicial = Linha nome 0 0 0 0 0 0

    acumular linha partida =
      let (gp, gc) =
            if mandante partida == nome
              then (golsMandante partida, golsVisitante partida)
              else (golsVisitante partida, golsMandante partida)

          resultado = resultadoPara nome partida

          v = if resultado == Just Vitoria then 1 else 0
          e = if resultado == Just Empate then 1 else 0
          d = if resultado == Just Derrota then 1 else 0

      in Linha
          { time = nome
          , jogos = jogos linha + 1
          , vitorias = vitorias linha + v
          , empates = empates linha + e
          , derrotas = derrotas linha + d
          , golsPro = golsPro linha + gp
          , golsContra = golsContra linha + gc
          }

pontosLinha :: Linha -> Int
pontosLinha linha =
  3 * vitorias linha + empates linha

saldo :: Linha -> Int
saldo linha = golsPro linha - golsContra linha

aproveitamento :: Linha -> Double
aproveitamento linha
  | jogos linha == 0 = 0
  | otherwise =
      100 * fromIntegral (pontosLinha linha)
      / fromIntegral (3 * jogos linha)

classificacao :: [Partida] -> [Linha]
classificacao partidas =
  sortBy comparar (map (linhaDoTime partidas) (times partidas))
  where
    comparar =
      comparing (Down . pontosLinha)
      <> comparing (Down . saldo)
      <> comparing (Down . golsPro)
      <> comparing time

ateRodada :: Int -> [Partida] -> [Partida]
ateRodada numero =
  filter ((<= numero) . rodada)

maiorGoleada :: [Partida] -> Maybe Partida
maiorGoleada =
  foldl' escolher Nothing
  where
    diferenca partida =
      abs (golsMandante partida - golsVisitante partida)

    escolher Nothing partida = Just partida
    escolher (Just atual) partida
      | diferenca partida > diferenca atual = Just partida
      | otherwise = Just atual

mediaGols :: [Partida] -> Maybe Double
mediaGols [] = Nothing
mediaGols partidas =
  Just (fromIntegral total / fromIntegral quantidade)
  where
    total = sum (map golsTotais partidas)
    quantidade = length partidas

    golsTotais partida =
      golsMandante partida + golsVisitante partida
