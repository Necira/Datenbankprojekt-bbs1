# Projektauftrag - BBS 1

## Teamverwaltungssoftware für ein MOBA (Multiplayer Online Battle Arena) Spiel

### Benötigte Projektkomponenten

Das nachfolgende Projekt benötigt eine Datenbank und GUI. Welche Technologien verwendet werden, ist der Gruppe überlassen. Die nachfolgenden Punkte müssen im Projekt vorhanden sein. Fehlende Auflistungspunkte im Projekt führen zu Punktabzug!.

### Anforderungen an die Software

Mitglieder sollen in der DB angelegt werden können. Es sind Spielername, Vorname, Nachname, E-Mailadresse und Spielposition (Top, Mid, Jungle usw.) zu erfassen. Weitere Informationen sind bei Bedarf hinzuzufügen. Mitglieder sollen nachträglich verändert und gelöscht werden können. Mitglieder können einem Team angehören, welches aus 5 Spielern besteht. Jeder Spieler besitzt eine Elo-Punktzahl. (hier entsprechende Recherche betreiben, welche Formeln für die El0-Berechnung verwendet werden kann).

Matchmaking-Mode (1v1): Es können jeweils 2 Spieler und ein Ausgang der Partie ausgewählt werden (z. B. Spieler 1 mit 1200 EloP gewinnt gegen Spieler 2 mit 1150 EloP). Nach einem Klick auf einen Button sollen die neuen EloPunkte bei beiden Spielern hintergelegt werden.

Matchmaking-Mode (Team vs Team): Selbes Vorgehen wie oben (hier TeamElo als Grundlage)
Turniermodus: Implementieren Sie die Möglichkeit (grafisch), dass mehrere Teams ein Turnier gegeneinander bestreiten können.

Turniermodus: Implementieren Sie die Möglichkeit (grafisch), dass mehrere Teams ein
Turnier gegeneinander bestreiten können

Suchfunktion, damit z. B. alle Spieler gesucht werden können, die als Position “Top“ spielen.

### Vorgehensweise

Die Arbeit erfolgt über Git, sowie Docker, sodass die Teamarbeit effizient und möglichst risikofrei verläuft. Eine Skizze jeder Seite mit Inhalten wurde gefertigt, wodurch ersichtlich wurde was genau bearbeitet werden muss. Dann erfassten wir das ER-Diagramm mit Inhalten und Datenbankstruktur.
Das Framework Vue wurde gewählt, um eine übersichtliche Arbeitsweise mit vorteilhafter strukturierung zu ermöglichen. Dann begann die Entwicklung nach dem top-down prinzip. Die Übersichtsseiten wurden erstellt, worauf die einzelnen Unterkategorien und letztlich Inhalte folgten. Es hat sich ein trunk-based Workflow entwickelt.

## Teamverwaltungssoftware starten

### Voraussetzungen
Auf dem Gerät muss [Docker](https://docs.docker.com/get-started/get-docker/) installiert sein, damit das Projekt ohne Probleme startet. 

Zudem müssen die Nutzerrechte des root-Nutzers vor dem eigentlich start des Projektes manuell angepasst werden, damit die Datenbankverbindung korrekt eingerichtet ist.

1. Starte den Container "Teamverwaltungssoftware" mit den angegebenen Befehlen im IDE-Terminal und öffne über das Terminal des mysql-Container über das drei-Punkte-Menü
```
cd teamverwaltungssoftware
docker compose build
docker compose up -d
```
<div align="center">
  <img src="https://github.com/user-attachments/assets/1c30c37a-8a0e-4e42-9c31-acac182dc185" width="40%" height="40%" />
  <img src="https://github.com/user-attachments/assets/aacc4704-b7c6-4807-9b01-1fe1dcb26c12" width="40%" height="40%" />
</div>

2. Greife auf den mysql root-Nutzer zu und gebe das Passwort "root" ein
```
mysql -u root -p
```

3. Gebe dem root-Nutzer alle benötigten Rechte
```
GRANT ALL PRIVILEGES ON Datenbankprojekt-BBS1 TO  'root'@'localhost' IDENTIFIED BY  'root'
```

4. Lade die Berechtigungstabelle neu
```
FLUSH PRIVILEGES
```

5. Schließe den mysql root-Nutzer, indem du zuerst die Tastenkombination Ctrl + C (Mac) / Strg + C (Windows) anwendest und den angegebenen Befehl eingibst:
```
quit
```

### Vue.js-Projekt starten

Das Projekt kann, insofern der Container in Docker angezeigt wird, auch darüber gestartet werden. Falls das nicht gewünscht ist, starte Docker im Hintergrund und führe die folgenden Befehle im Terminal der IDE aus, wenn du das Projekt auf einem anderen Weg starten möchtest:

```
cd teamverwaltungssoftware
docker compose build
docker compose up -d
```
