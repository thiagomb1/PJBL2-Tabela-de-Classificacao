
module Dados (dadosCampeonato) where

-- Campeonato ficticio com 6 times e 5 rodadas.
-- Cada time joga exatamente uma vez por rodada.
-- Formato: rodada;mandante;golsMandante;golsVisitante;visitante

dadosCampeonato :: String
dadosCampeonato = unlines
  [ "# Campeonato Paranaense - Simulacao"
  , "# Rodada 1"
  , "1;Coritiba;3;0;Maringa"
  , "1;Athletico;1;1;Londrina"
  , "1;Parana;0;0;Operario"

  , "# Rodada 2"
  , "2;Coritiba;1;1;Londrina"
  , "2;Maringa;1;1;Operario"
  , "2;Athletico;2;1;Parana"

  , "# Rodada 3"
  , "3;Coritiba;1;1;Operario"
  , "3;Londrina;0;2;Parana"
  , "3;Maringa;1;1;Athletico"

  , "# Rodada 4"
  , "4;Coritiba;1;1;Parana"
  , "4;Operario;1;0;Athletico"
  , "4;Londrina;1;1;Maringa"

  , "# Rodada 5"
  , "5;Coritiba;0;1;Athletico"
  , "5;Parana;1;1;Maringa"
  , "5;Operario;1;1;Londrina"
  ]
