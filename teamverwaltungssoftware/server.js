const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors());
app.listen(port, () => {
    console.log('server runs on http://localhost:' + port);
});

let connection = mysql.createConnection({
    host: 'mysql', // Hier den Container-Namen verwenden
    user: 'root',
    password: 'root', // Falls du ein Passwort gesetzt hast, gebe es hier an
    database: 'Datenbankprojekt-BBS1',
});

// API-Endpoint to create new player
app.post('/createNewPlayer', (req, res) => {
    let { newPlayername, newFirstname, newLastname, newEmail, newPosition, newEloPoints } = req.body;
    connection.query(
        'INSERT INTO `player` (`playername`, `firstname`, `lastname`, `email`, `position`, `eloPoints`) VALUES (?, ?, ?, ?, ?, ?)',
        [newPlayername, newFirstname, newLastname, newEmail, newPosition, newEloPoints],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to get all player
app.get('/getPlayer', (req, res) => {
    connection.query('SELECT * FROM `player`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to get all active player
app.get('/getActivePlayer', (req, res) => {
    connection.query('SELECT * FROM `player` WHERE `deleted` = 0', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to get all active player that are not in a team yet
app.get('/getActiveTeammember', (req, res) => {
    connection.query(
        'SELECT * FROM `player` WHERE `deleted` = 0 AND `playerID` = (SELECT `firstMember` FROM `teams` WHERE `firstMember` = `playerID`) OR `playerID` = (SELECT `secondMember` FROM `teams` WHERE `secondMember` = `playerID`) OR `playerID` = (SELECT `thirdMember` FROM `teams` WHERE `thirdMember` = `playerID`) OR `playerID` = (SELECT `fourthMember` FROM `teams` WHERE `fourthMember` = `playerID`) OR `playerID` = (SELECT `fifthMember` FROM `teams` WHERE `fifthMember` = `playerID`)',
        (err, rows) => {
            if (err) {
                console.error(err);
            } else {
                res.json(rows);
            }
        },
    );
});

// API-Endpoint to update a specific player
app.put('/updatePlayer', (req, res) => {
    let {
        changedPlayername,
        changedFirstname,
        changedLastname,
        changedEmail,
        changedPosition,
        changedEloPoints,
        changedDeletedValue,
        playerId,
    } = req.body;

    connection.query(
        'UPDATE `player` SET `playername` = ?, `firstname` = ?, `lastname`= ?, `email` = ?, `position` = ?, `eloPoints`= ?, `deleted`= ? WHERE `playerID` = ?',
        [
            changedPlayername,
            changedFirstname,
            changedLastname,
            changedEmail,
            changedPosition,
            changedEloPoints,
            changedDeletedValue,
            playerId,
        ],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to delete a specific player
app.patch('/deletePlayer', (req, res) => {
    const { valueDeleted, deletedPlayerId } = req.body;
    connection.query(
        'UPDATE `player` SET `deleted` = ? WHERE `playerID` = ?',
        [valueDeleted, deletedPlayerId],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to create new team
app.post('/createNewTeam', (req, res) => {
    let { newTeamname, newEloPoints, firstMember, secondMember, thirdMember, fourthMember, fifthMember } =
        req.body;
    connection.query(
        'INSERT INTO `teams` (`teamname`, `eloPoints`, `firstMember`, `secondMember`,`thirdMember`,`fourthMember`,`fifthMember`) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [newTeamname, newEloPoints, firstMember, secondMember, thirdMember, fourthMember, fifthMember],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});

// API-Endpoint to get all teams
app.get('/getTeams', (req, res) => {
    connection.query('SELECT * FROM `teams`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to get all active teams
app.get('/getActiveTeams', (req, res) => {
    connection.query('SELECT * FROM `teams` WHERE `deleted` = 0', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to delete a specific team
app.patch('/deleteTeam', (req, res) => {
    const { valueDeleted, deletedTeamID } = req.body;
    connection.query(
        'UPDATE `teams` SET `deleted` = ? WHERE `teamID` = ?',
        [valueDeleted, deletedTeamID],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});
