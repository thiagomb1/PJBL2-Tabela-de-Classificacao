
module Leitura
  ( Erro(..)
  , separar
  , lerPartida
  , lerCampeonato
  , todosOsErros
  , tabelaFormatada
  ) where

import Tipos
import Classificacao (pontosLinha, saldo)
import Data.Char (isSpace)
import Data.List (intercalate, nub)
import Data.Either (lefts)
import Text.Read (readMaybe)

data Erro
  = CamposInvalidos Int
  | NumeroInvalido Int String
  | PlacarNegativo Int
  | MesmoTime Int
  | TimeRepetidoNaRodada Int Time
  | NomeVazio Int
  | RodadaInvalida Int
  deriving (Eq, Show)

separar :: Char -> String -> [String]
separar separador texto =
  case break (== separador) texto of
    (parte, []) -> [parte]
    (parte, _:resto) -> parte : separar separador resto

limpar :: String -> String
limpar = reverse . dropWhile isSpace . reverse . dropWhile isSpace

lerNumero :: Int -> String -> Either Erro Int
lerNumero numeroLinha texto =
  maybe (Left (NumeroInvalido numeroLinha texto)) Right
    (readMaybe (limpar texto) :: Maybe Int)

lerPartida :: Int -> String -> Either Erro Partida
lerPartida numeroLinha texto =
  case map limpar (separar ';' texto) of
    [r, casa, gm, gv, fora] -> do
      numeroRodada <- lerNumero numeroLinha r
      golsCasa <- lerNumero numeroLinha gm
      golsFora <- lerNumero numeroLinha gv

      if numeroRodada <= 0
        then Left (RodadaInvalida numeroLinha)
      else if null casa || null fora
        then Left (NomeVazio numeroLinha)
      else if golsCasa < 0 || golsFora < 0
        then Left (PlacarNegativo numeroLinha)
      else if casa == fora
        then Left (MesmoTime numeroLinha)
      else Right (Partida numeroRodada casa golsCasa golsFora fora)

    _ -> Left (CamposInvalidos numeroLinha)

linhasValidas :: String -> [(Int, String)]
linhasValidas texto =
  filter (not . ignorar . snd) (zip [1..] (lines texto))
  where
    ignorar linha =
      let conteudo = limpar linha
      in null conteudo || take 1 conteudo == "#"

errosDeRepeticao :: [Partida] -> [Erro]
errosDeRepeticao partidas =
  concatMap verificarRodada rodadas
  where
    rodadas = nub (map rodada partidas)

    verificarRodada numero =
      let jogosRodada = filter ((== numero) . rodada) partidas
          participantes = concatMap
            (\p -> [mandante p, visitante p]) jogosRodada
          repetidos = nub
            [t | t <- participantes, length (filter (== t) participantes) > 1]
      in map (TimeRepetidoNaRodada numero) repetidos

lerCampeonato :: String -> Either Erro [Partida]
lerCampeonato texto = do
  partidas <- traverse (uncurry lerPartida) (linhasValidas texto)
  case errosDeRepeticao partidas of
    [] -> Right partidas
    (erro:_) -> Left erro

todosOsErros :: String -> [Erro]
todosOsErros texto =
  errosLeitura ++ errosRepeticao
  where
    resultados = map (uncurry lerPartida) (linhasValidas texto)
    errosLeitura = lefts resultados
    partidasValidas = [p | Right p <- resultados]
    errosRepeticao = errosDeRepeticao partidasValidas

tabelaFormatada :: [Linha] -> String
tabelaFormatada linhas =
  unlines (cabecalho : separador : zipWith formatar [1 :: Int ..] linhas)
  where
    cabecalho = intercalate " | "
      ["POS", "TIME", "PTS", "J", "V", "E", "D", "SG"]

    separador = replicate 55 '-'

    formatar pos linha =
      intercalate " | "
        [ show pos
        , time linha
        , show (pontosLinha linha)
        , show (jogos linha)
        , show (vitorias linha)
        , show (empates linha)
        , show (derrotas linha)
        , show (saldo linha)
        ]
