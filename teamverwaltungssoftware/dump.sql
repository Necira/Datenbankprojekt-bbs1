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
(1, 'Louis', 'louis', 'Lohmer', 'louis.lohmer@mediaman.de', 'Top-Lane', 1300, 0),
(2, 'Necira', 'Maria', 'Neciporenko', 'marianeciporenko@gmail.com', 'Bot-Lane', 1200, 0),
(3, 'Muster', 'Max', 'Mustermann', 'max.mustermann@mediaman.de', 'Support', 1230, 0),
(4, 'whatThe', 'What', 'the', 'whatthe@lol.de', 'Jungle', 1200, 0),
(5, 'test', 'testfirstname', 'testlastname', 'olaf.scholz@gmail.com', 'Mid-lane', 1230, 0),
(6, 'NoFPS2', 'hello', 'world', 'helloworld@mediaman.de', 'Top-Lane', 1200, 0),
(7, 'testi', 'testplayer', 'Lohmer', 'helloworld@mediaman.de', 'Mid-lane', 1200, 0),
(8, 'lol', 'louis', 'Lohmer', 'max.mustermann@mediaman.de', 'Support', 1400, 0),
(9, 'Vendetta', 'V', 'forVendetta', 'v.vendetta@gmail.de', 'Bot-Lane', 1000, 0),
(10, 'strangePerson', 'strange', 'notsostrange', 'strange.notsostrange@strange.de', 'Jungle', 1400, 0),
(11, 'Travolta', 'Trav', 'olta', 'trav.olter@gmail.de', 'Top-Lane', 1300, 0),
(12, 'TypeSalty', 'Typ', 'Salzig', 'Salzig@gmail.com', 'Bot-Lane', 1200, 0),
(13, 'Hello hideous', 'Hello', 'hideous', 'hell.hid@mediaman.de', 'Support', 1230, 0),
(14, 'dreadcaptain', 'Captain', 'Dredd', 'Cpt@lol.de', 'Jungle', 1200, 0),
(15, 'Soulcrow', 'Krähe', 'Seele', 'Soulcrow@gmail.com', 'Mid-lane', 1230, 0),
(16, 'Thuja', 'Thu', 'Ja', 'JaThu@mediaman.de', 'Top-Lane', 1200, 0),
(17, 'mimimimimi', 'Mi', 'Mimi', 'crying@mediaman.de', 'Mid-lane', 1200, 0),
(18, 'Instinct9', 'Neun', 'Instinkt', 'Neunter@mediaman.de', 'Support', 1400, 0),
(19, 'illoru', 'Ill', 'Oru', 'Illoru@gmail.de', 'Bot-Lane', 1000, 0),
(20, 'Berto Castro', 'Berto', 'Castro', 'Castro@strange.de', 'Jungle', 1400, 0),
(21, 'MadThroes', 'Mad', 'Throes', 'Mad@mediaman.de', 'Top-Lane', 1300, 0),
(22, 'Pyke Tyson', 'Pyke', 'Tyson', 'PykeTyson@gmail.com', 'Bot-Lane', 1200, 0),
(23, 'jacob theher', 'jacob', 'theher', 'jacob@mediaman.de', 'Support', 1230, 0),
(24, 'RatardChopper', 'Rat', 'Chopper', 'RatChopper@lol.de', 'Jungle', 1200, 0),
(25, 'Phleip', 'Phl', 'Eip', 'Phleip@gmail.com', 'Mid-lane', 1230, 0),
(26, 'Chico', 'Chi', 'Co', 'Chico@mediaman.de', 'Top-Lane', 1200, 0),
(27, 'Goonzalz', 'Goon', 'Zalz', 'Goon@mediaman.de', 'Mid-lane', 1200, 0),
(28, 'Seergii', 'Seer', 'Gii', 'Seergii@mediaman.de', 'Support', 1400, 0),
(29, 'El Doma', 'El', 'Doma', 'Doma@gmail.de', 'Bot-Lane', 1000, 0),
(30, 'realTangus', 'real', 'Tangus', 'Tangus@strange.de', 'Jungle', 1400, 0),
(31, 'Machs', 'Max', 'Chs', 'Machs@mediaman.de', 'Top-Lane', 1300, 0),
(32, 'Spork', 'Spoon', 'Fork', 'Spork@gmail.com', 'Bot-Lane', 1200, 0),
(33, 'Frostraider', 'Frost', 'Raider', 'FrostRaider@mediaman.de', 'Support', 1230, 0),
(34, 'FCYugo', 'FC', 'Yugo', 'FCYugo@lol.de', 'Jungle', 1200, 0),
(35, 'Dunkocalypse', 'Dunko', 'Calypse', 'Dunkocalypse@gmail.com', 'Mid-lane', 1230, 0),
(36, 'Legreb', 'Leg', 'Reb', 'Legreb@mediaman.de', 'Top-Lane', 1200, 0),
(37, 'Pneumatico', 'Pneu', 'Matico', 'Pneumatico@mediaman.de', 'Mid-lane', 1200, 0),
(38, 'Amicetta', 'Ami', 'Cetta', 'Amicetta@mediaman.de', 'Support', 1400, 0),
(39, 'Goldfishing', 'Gold', 'Fishing', 'Gold@gmail.de', 'Bot-Lane', 1000, 0),
(40, 'geniusBread', 'Genius', 'Bread', 'Bread@strange.de', 'Jungle', 1400, 0),
(41, 'Trickster', 'Trick', 'Ster', 'Trickster@mediaman.de', 'Top-Lane', 1300, 0),
(42, 'NFC Omega', 'NFC', 'Omega', 'NFCOmega@gmail.com', 'Bot-Lane', 1200, 0),
(43, 'Another Loss', 'Another', 'Loss', 'AnotherLoss@mediaman.de', 'Support', 1230, 0),
(44, 'SO Blue', 'SO', 'Blue', 'SOBlue@lol.de', 'Jungle', 1200, 0),
(45, 'NFC Jolly', 'NFC', 'Jolly', 'NFC Jolly@gmail.com', 'Mid-lane', 1230, 0),
(46, 'HideonBush', 'Fake', 'Bush', 'Bush@mediaman.de', 'Top-Lane', 1200, 0),
(47, 'T1 FakeR', 'Faker', 'teins', 'Fake@mediaman.de', 'Mid-lane', 1200, 0),
(48, 'aweesde', 'Chris', 'Toph', 'aweesde@mediaman.de', 'Support', 1400, 0),
(49, 'Skroli', 'Oli', 'Ver', 'Oliver@gmail.de', 'Bot-Lane', 1000, 0),
(50, 'TinySkillz', 'Tiny', 'Skillz', 'Tiny@strange.de', 'Jungle', 1400, 0);

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
(1, 'NierAutomata', 1232, 0, 1, 2, 3, 4, 5),
(2, 'LeagueOfLegends', 1240, 0, 6, 7, 8, 9, 10),
(3, 'Persona', 1, 0, NULL, NULL, NULL, NULL, NULL),
(4, 'TheWitcher', 1, 0, NULL, NULL, NULL, NULL, NULL),
(5, 'GenshinImpact', 1, 0, NULL, NULL, NULL, NULL, NULL),
(6, 'Cyberpunk', 1, 0, NULL, NULL, NULL, NULL, NULL),
(7, 'BaldursGate', 1, 0, NULL, NULL, NULL, NULL, NULL),
(8, 'Minecraft', 1, 0, NULL, NULL, NULL, NULL, NULL),
(9, 'AssassinsCreed', 1, 0, NULL, NULL, NULL, NULL, NULL),
(10, 'GhostOfTsushima', 1, 0, NULL, NULL, NULL, NULL, NULL),
(11, 'HonkaiStarrail', 1, 0, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tournament`
--

CREATE TABLE `tournament` (
  `tournament_ID` int(11) NOT NULL,
  `team_ID` int(11) NOT NULL,
  `teamname` varchar(255) NOT NULL,
  `FirstRound` tinyint(1) DEFAULT 0,
  `SecondRound` tinyint(1) DEFAULT 0,
  `ThirdRound` tinyint(1) DEFAULT 0,
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
-- Indizes für die Tabelle `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`teamID`),
  ADD KEY `firstMember` (`firstMember`),
  ADD KEY `secondMember` (`secondMember`),
  ADD KEY `thirdMember` (`thirdMember`),
  ADD KEY `fourthMember` (`fourthMember`),
  ADD KEY `fifthMember` (`fifthMember`);

--  Änderung der Tabelle teams (z. B. Ändern der Spalte teamID)
ALTER TABLE teams MODIFY teamID INT(11) NOT NULL AUTO_INCREMENT;

-- Primary key mit automatischem Aufsteigen für tournament Tabelle
ALTER TABLE `tournament`
MODIFY COLUMN tournament_ID INT AUTO_INCREMENT PRIMARY KEY;
--  Hinzufügen des Fremdschlüssels
ALTER TABLE `tournament`
  ADD CONSTRAINT `tournament_ibfk_1` FOREIGN KEY (`team_ID`) REFERENCES `teams` (`teamID`)
  ON DELETE CASCADE ON UPDATE CASCADE;

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
-- AUTO_INCREMENT für Tabelle `TvsT`
--
ALTER TABLE `TvsT`
  MODIFY `TvsT-ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

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
