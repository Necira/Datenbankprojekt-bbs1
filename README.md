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
Das Framework Vue wurde gewählt, um eine übersichtliche Arbeitsweise mit vorteilhafter strukturierung zu ermöglichen. Dann begann die Entwicklung nach dem top-down prinzip. Die Übersichtsseiten wurden erstellt, worauf die einzelnen Unterkategorien und letztlich Inhalte folgten.

## Teamverwaltungssoftware starten

### Voraussetzungen
Auf dem Gerät muss die [aktuellste Version von Node.js](https://nodejs.org/en/download/package-manager), der Node Version Manager (nvm) für das entsprechende Betriebssystem, Docker sowie [die aktuellste Version von axios](https://axios-http.com/docs/intro) installiert sein, damit das Projekt ohne Probleme startet.

Um mit der Datenbank über CRUD-Operationen interagieren zu können, muss diese im Hintergrund laufen und die Datei "Server.js", welche die Datenbankverbindungen vom Frontend herstellt, muss auch gestartet werden. Dies erfolgt mithilfe der folgenden Befehle im Terminal der IDE:
```
cd teamverwaltungssoftware
cd src
node server.js
```
Bei einem erfolgreichen Start der Datei wird die folgende Nachricht im Terminal ausgeben: "server runs on http://localhost:3000"

### Vue.js-Projekt starten
Führe die folgenden Befehle in der angegebenen Reihenfolge im Terminal der IDE aus, wenn du das Projekt zum ersten mal startest:
```
cd teamverwaltungssoftware
npm install
nvm use 21
npm run serve
```

Führe die folgenden Befehle in der angegebenen Reihenfolge im Terminal der IDE aus, wenn du das Projekt schon mal gestartet hat:
```
cd teamverwaltungssoftware
nvm use 21
npm run serve
```
