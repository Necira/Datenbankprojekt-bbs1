-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 03. Jan 2025 um 16:02
-- Server-Version: 10.4.28-MariaDB
-- PHP-Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `Datenbankprojekt-BBS1`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `1vs1`
--

CREATE TABLE `1vs1` (
  `1vs1-ID` int(11) NOT NULL,
  `firstPlayer` varchar(255) NOT NULL,
  `secondPlayer` varchar(255) NOT NULL,
  `result` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `player`
--

CREATE TABLE `player` (
  `playerID` int(11) NOT NULL,
  `playername` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `eloPoints` int(10) UNSIGNED NOT NULL,
  `deleted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `player`
--

INSERT INTO `player` (`playerID`, `playername`, `firstname`, `lastname`, `email`, `position`, `eloPoints`, `deleted`) VALUES
(9, 'NoFPS', 'louis', 'Lohmer', 'louis.lohmer@mediaman.de', 'top', 1300, 0),
(15, 'test', 'Maria', 'Neciporenko', 'marianeciporenko@gmail.com', 'bot', 1200, 0),
(16, 'YesFPS', 'Max', 'Mustermann', 'max.mustermann@mediaman.de', 'top', 1230, 0),
(17, 'NoFPS23', 'What', 'the', 'whatthe@lol.de', 'left', 1200, 0),
(18, 'test23', 'testfirstname', 'testlastname', 'olaf.scholz@gmail.com', 'top', 1230, 0),
(19, 'NoFPS2', 'hello', 'world', 'helloworld@mediaman.de', 'top', 1200, 0),
(20, 'testi', 'testplayer', 'Lohmer', 'louis.lohmer@mediaman.de', 'top', 1200, 0),
(21, 'testi2', 'louis', 'Lohmer', 'max.mustermann@mediaman.de', 'testTop', 1400, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `rounds`
--

CREATE TABLE `rounds` (
  `tournament-ID` int(11) NOT NULL,
  `round` int(11) NOT NULL,
  `firstParticipant` varchar(255) NOT NULL,
  `secondParticipant` varchar(255) NOT NULL,
  `result` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `teams`
--

CREATE TABLE `teams` (
  `teamID` int(11) NOT NULL,
  `teamname` varchar(255) NOT NULL,
  `eloPoints` int(10) UNSIGNED NOT NULL,
  `deleted` tinyint(1) DEFAULT 0,
  `firstMember` int(11) DEFAULT NULL,
  `secondMember` int(11) DEFAULT NULL,
  `thirdMember` int(11) DEFAULT NULL,
  `fourthMember` int(11) DEFAULT NULL,
  `fifthMember` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `teams`
--

INSERT INTO `teams` (`teamID`, `teamname`, `eloPoints`, `deleted`, `firstMember`, `secondMember`, `thirdMember`, `fourthMember`, `fifthMember`) VALUES
(7, 'testTeam', 1300, 1, NULL, NULL, NULL, NULL, NULL),
(8, 'testTeam4', 1234, 0, NULL, NULL, NULL, NULL, NULL),
(23, 'testTeam5', 1569, 0, NULL, NULL, NULL, NULL, NULL),
(28, 'testTeam6', 6060, 1, 16, 17, 18, 19, 20);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tournament`
--

CREATE TABLE `tournament` (
  `tournament-ID` int(11) NOT NULL,
  `winner` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `TvsT`
--

CREATE TABLE `TvsT` (
  `TvsT-ID` int(11) NOT NULL,
  `firstTeam` varchar(255) NOT NULL,
  `secondTeam` varchar(255) NOT NULL,
  `result` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `1vs1`
--
ALTER TABLE `1vs1`
  ADD PRIMARY KEY (`1vs1-ID`);

--
-- Indizes für die Tabelle `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`playerID`);

--
-- Indizes für die Tabelle `rounds`
--
ALTER TABLE `rounds`
  ADD PRIMARY KEY (`tournament-ID`,`round`);

--
-- Indizes für die Tabelle `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`teamID`),
  ADD KEY `firstMember` (`firstMember`),
  ADD KEY `secondMember` (`secondMember`),
  ADD KEY `thirdMember` (`thirdMember`),
  ADD KEY `fourthMember` (`fourthMember`),
  ADD KEY `fifthMember` (`fifthMember`);

--
-- Indizes für die Tabelle `tournament`
--
ALTER TABLE `tournament`
  ADD PRIMARY KEY (`tournament-ID`);

--
-- Indizes für die Tabelle `TvsT`
--
ALTER TABLE `TvsT`
  ADD PRIMARY KEY (`TvsT-ID`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `1vs1`
--
ALTER TABLE `1vs1`
  MODIFY `1vs1-ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `player`
--
ALTER TABLE `player`
  MODIFY `playerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT für Tabelle `teams`
--
ALTER TABLE `teams`
  MODIFY `teamID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT für Tabelle `tournament`
--
ALTER TABLE `tournament`
  MODIFY `tournament-ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `TvsT`
--
ALTER TABLE `TvsT`
  MODIFY `TvsT-ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `rounds`
--
ALTER TABLE `rounds`
  ADD CONSTRAINT `rounds_ibfk_1` FOREIGN KEY (`tournament-ID`) REFERENCES `tournament` (`tournament-ID`);

--
-- Constraints der Tabelle `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`firstMember`) REFERENCES `player` (`playerID`),
  ADD CONSTRAINT `teams_ibfk_2` FOREIGN KEY (`secondMember`) REFERENCES `player` (`playerID`),
  ADD CONSTRAINT `teams_ibfk_3` FOREIGN KEY (`thirdMember`) REFERENCES `player` (`playerID`),
  ADD CONSTRAINT `teams_ibfk_4` FOREIGN KEY (`fourthMember`) REFERENCES `player` (`playerID`),
  ADD CONSTRAINT `teams_ibfk_5` FOREIGN KEY (`fifthMember`) REFERENCES `player` (`playerID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
