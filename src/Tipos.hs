
module Tipos
  ( Time
  , Resultado(..)
  , Partida(..)
  , Linha(..)
  , participou
  , resultadoPara
  , times
  ) where

import Data.List (nub, sort)

type Time = String

data Resultado = Vitoria | Empate | Derrota
  deriving (Show, Eq)

data Partida = Partida
  { rodada        :: Int
  , mandante      :: Time
  , golsMandante  :: Int
  , golsVisitante :: Int
  , visitante     :: Time
  } deriving (Show, Eq)

data Linha = Linha
  { time     :: Time
  , jogos    :: Int
  , vitorias :: Int
  , empates  :: Int
  , derrotas :: Int
  , golsPro  :: Int
  , golsContra :: Int
  } deriving (Show, Eq)

participou :: Time -> Partida -> Bool
participou t p =
  t == mandante p || t == visitante p

resultadoPara :: Time -> Partida -> Maybe Resultado
resultadoPara t p
  | not (participou t p) = Nothing
  | golsDoTime > golsAdversario = Just Vitoria
  | golsDoTime < golsAdversario = Just Derrota
  | otherwise = Just Empate
  where
    (golsDoTime, golsAdversario)
      | t == mandante p =
          (golsMandante p, golsVisitante p)
      | otherwise =
          (golsVisitante p, golsMandante p)

times :: [Partida] -> [Time]
times partidas =
  sort . nub $ concatMap
    (\p -> [mandante p, visitante p])
    partidas
