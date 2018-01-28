-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Creato il: Nov 07, 2017 alle 18:32
-- Versione del server: 10.1.28-MariaDB
-- Versione PHP: 7.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `storedb`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `acquisto`
--

CREATE TABLE `acquisto` (
  `id_ordine` int(11) NOT NULL,
  `id_articolo` int(11) NOT NULL,
  `stato` varchar(100) NOT NULL DEFAULT 'pending',
  `prezzo` double DEFAULT NULL,
  `data` date NOT NULL,
  `quantità` int(11) NOT NULL,
  `lettura` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `articolo`
--

CREATE TABLE `articolo` (
  `id_articolo` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `descrizione` text,
  `foto` varchar(255) DEFAULT NULL,
  `prezzo` double NOT NULL,
  `media_recensioni` double NOT NULL DEFAULT '0',
  `n_recensioni` int(11) DEFAULT NULL,
  `negozio` varchar(255) NOT NULL,
  `data_inserimento` date NOT NULL,
  `categoria_1` varchar(255) NOT NULL,
  `categoria_2` varchar(255) DEFAULT NULL,
  `categoria_3` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struttura della tabella `categoria`
--

CREATE TABLE `categoria` (
  `nome_categoria` varchar(255) NOT NULL,
  `desc_categoria` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `citta`
--

CREATE TABLE `citta` (
  `nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `coordinate`
--

CREATE TABLE `coordinate` (
  `id` int(11) NOT NULL,
  `latitudine` double NOT NULL,
  `longitudine` double NOT NULL,
  `address` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `negozio`
--

CREATE TABLE `negozio` (
  `nome` varchar(255) NOT NULL,
  `venditore` varchar(255) NOT NULL,
  `descrizione` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `negozio_fisico`
--

CREATE TABLE `negozio_fisico` (
  `nome` varchar(255) NOT NULL,
  `orari` varchar(255) DEFAULT NULL,
  `coordinate` int(11) NOT NULL,
  `citta` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struttura della tabella `ordine`
--

CREATE TABLE `ordine` (
  `id_ordine` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `totale` double NOT NULL,
  `data` date NOT NULL,
  `pagamento` varchar(255) DEFAULT NULL,
  `modalità` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `recensione`
--

CREATE TABLE `recensione` (
  `utente` varchar(255) NOT NULL,
  `id_articolo` int(11) NOT NULL,
  `testo` varchar(255) NOT NULL,
  `voto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Trigger `recensione`
--

CREATE TRIGGER `after_delete_recensione` AFTER DELETE ON `recensione` FOR EACH ROW UPDATE articolo
    SET  media_recensioni = (n_recensioni * media_recensioni - OLD.voto) / (n_recensioni -1),
		 n_recensioni = n_recensioni-1
    WHERE articolo.id_articolo = OLD.id_articolo;


CREATE TRIGGER `after_insert_recensione` AFTER INSERT ON `recensione` FOR EACH ROW UPDATE articolo
    SET  media_recensioni = (n_recensioni * media_recensioni + NEW.voto) / (n_recensioni + 1),
		 n_recensioni = n_recensioni+1
    WHERE articolo.id_articolo = NEW.id_articolo;

CREATE TRIGGER `after_update_recensione` AFTER UPDATE ON `recensione` FOR EACH ROW UPDATE articolo
    SET  media_recensioni = (n_recensioni * media_recensioni - OLD.voto + NEW.voto) / (n_recensioni)
    WHERE articolo.id_articolo = NEW.id_articolo;

-- --------------------------------------------------------

--
-- Struttura della tabella `segnalazione`
--

CREATE TABLE `segnalazione` (
  `id_messaggio` int(11) NOT NULL,
  `id_mittente` varchar(255) NOT NULL,
  `id_destinatario` varchar(255) NOT NULL,
  `id_ordine` int(11) NOT NULL,
  `id_articolo` int(11) NOT NULL,
  `data_acquisto` date NOT NULL,
  `oggetto` varchar(255) NOT NULL,
  `testo` varchar(255) NOT NULL,
  `data` date NOT NULL,
  `stato` varchar(255) DEFAULT 'aperta',
  `conseguenza` varchar(1) DEFAULT NULL,
  `lettura` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struttura della tabella `utente`
--

CREATE TABLE `utente` (
  `nome` varchar(100) NOT NULL,
  `cognome` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `data_registrazione` date NOT NULL,
  `data_conferma_registrazione` date DEFAULT NULL,
  `tipo_utente` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Struttura della tabella `venditore`
--

CREATE TABLE `venditore` (
  `utente` varchar(255) NOT NULL,
  `data_registrazione` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `acquisto`
--
ALTER TABLE `acquisto`
  ADD PRIMARY KEY (`id_ordine`,`id_articolo`,`data`),
  ADD KEY `id_articolo` (`id_articolo`);

--
-- Indici per le tabelle `articolo`
--
ALTER TABLE `articolo`
  ADD PRIMARY KEY (`id_articolo`),
  ADD KEY `categoria_1` (`categoria_1`),
  ADD KEY `categoria_2` (`categoria_2`),
  ADD KEY `categoria_3` (`categoria_3`),
  ADD KEY `negozio` (`negozio`);

--
-- Indici per le tabelle `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`nome_categoria`);

--
-- Indici per le tabelle `citta`
--
ALTER TABLE `citta`
  ADD PRIMARY KEY (`nome`);

--
-- Indici per le tabelle `coordinate`
--
ALTER TABLE `coordinate`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `negozio`
--
ALTER TABLE `negozio`
  ADD PRIMARY KEY (`nome`),
  ADD KEY `venditore` (`venditore`);

--
-- Indici per le tabelle `negozio_fisico`
--
ALTER TABLE `negozio_fisico`
  ADD PRIMARY KEY (`nome`),
  ADD KEY `coordinate` (`coordinate`),
  ADD KEY `citta` (`citta`);

--
-- Indici per le tabelle `ordine`
--
ALTER TABLE `ordine`
  ADD PRIMARY KEY (`id_ordine`,`data`),
  ADD KEY `user` (`user`);

--
-- Indici per le tabelle `recensione`
--
ALTER TABLE `recensione`
  ADD PRIMARY KEY (`utente`,`id_articolo`),
  ADD KEY `id_articolo` (`id_articolo`);

--
-- Indici per le tabelle `segnalazione`
--
ALTER TABLE `segnalazione`
  ADD PRIMARY KEY (`id_messaggio`),
  ADD KEY `id_mittente` (`id_mittente`),
  ADD KEY `id_destinatario` (`id_destinatario`),
  ADD KEY `id_ordine` (`id_ordine`),
  ADD KEY `id_articolo` (`id_articolo`);

--
-- Indici per le tabelle `utente`
--
ALTER TABLE `utente`
  ADD PRIMARY KEY (`email`);

--
-- Indici per le tabelle `venditore`
--
ALTER TABLE `venditore`
  ADD PRIMARY KEY (`utente`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `articolo`
--
ALTER TABLE `articolo`
  MODIFY `id_articolo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `ordine`
--
ALTER TABLE `ordine`
  MODIFY `id_ordine` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT per la tabella `segnalazione`
--
ALTER TABLE `segnalazione`
  MODIFY `id_messaggio` int(11) NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `acquisto`
--
ALTER TABLE `acquisto`
  ADD CONSTRAINT `acquisto_ibfk_1` FOREIGN KEY (`id_ordine`) REFERENCES `ordine` (`id_ordine`),
  ADD CONSTRAINT `acquisto_ibfk_2` FOREIGN KEY (`id_articolo`) REFERENCES `articolo` (`id_articolo`);

--
-- Limiti per la tabella `articolo`
--
ALTER TABLE `articolo`
  ADD CONSTRAINT `articolo_ibfk_1` FOREIGN KEY (`categoria_1`) REFERENCES `categoria` (`nome_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `articolo_ibfk_2` FOREIGN KEY (`categoria_2`) REFERENCES `categoria` (`nome_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `articolo_ibfk_3` FOREIGN KEY (`categoria_3`) REFERENCES `categoria` (`nome_categoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `articolo_ibfk_4` FOREIGN KEY (`negozio`) REFERENCES `negozio` (`nome`);

--
-- Limiti per la tabella `negozio`
--
ALTER TABLE `negozio`
  ADD CONSTRAINT `negozio_ibfk_1` FOREIGN KEY (`venditore`) REFERENCES `utente` (`email`);

--
-- Limiti per la tabella `negozio_fisico`
--
ALTER TABLE `negozio_fisico`
  ADD CONSTRAINT `negozio_fisico_ibfk_1` FOREIGN KEY (`nome`) REFERENCES `negozio` (`nome`),
  ADD CONSTRAINT `negozio_fisico_ibfk_2` FOREIGN KEY (`coordinate`) REFERENCES `coordinate` (`id`),
  ADD CONSTRAINT `negozio_fisico_ibfk_3` FOREIGN KEY (`citta`) REFERENCES `citta` (`nome`);

--
-- Limiti per la tabella `ordine`
--
ALTER TABLE `ordine`
  ADD CONSTRAINT `ordine_ibfk_1` FOREIGN KEY (`user`) REFERENCES `utente` (`email`);

--
-- Limiti per la tabella `recensione`
--
ALTER TABLE `recensione`
  ADD CONSTRAINT `recensione_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `utente` (`email`),
  ADD CONSTRAINT `recensione_ibfk_2` FOREIGN KEY (`id_articolo`) REFERENCES `articolo` (`id_articolo`);

--
-- Limiti per la tabella `segnalazione`
--
ALTER TABLE `segnalazione`
  ADD CONSTRAINT `segnalazione_ibfk_1` FOREIGN KEY (`id_mittente`) REFERENCES `utente` (`email`),
  ADD CONSTRAINT `segnalazione_ibfk_2` FOREIGN KEY (`id_destinatario`) REFERENCES `utente` (`email`),
  ADD CONSTRAINT `segnalazione_ibfk_3` FOREIGN KEY (`id_ordine`) REFERENCES `acquisto` (`id_ordine`),
  ADD CONSTRAINT `segnalazione_ibfk_4` FOREIGN KEY (`id_articolo`) REFERENCES `acquisto` (`id_articolo`);

--
-- Limiti per la tabella `venditore`
--
ALTER TABLE `venditore`
  ADD CONSTRAINT `venditore_ibfk_1` FOREIGN KEY (`utente`) REFERENCES `utente` (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
