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
        'SELECT * FROM `player` INNER JOIN `teams` ON `player`.`playerID` = `teams`.`firstMember` OR `player`.`playerID` = `teams`.`secondMember` OR `player`.`playerID` = `teams`.`thirdMember` OR `player`.`playerID` = `teams`.`fourthMember` OR `player`.`playerID` = `teams`.`fifthMember` WHERE `player`.`deleted` = 0',
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
app.post('/updateWinner', (req, res) => {
    const { winner, teamOne, teamTwo } = req.body;
    const winnerTeam = winner;

    const query = `
        INSERT INTO tournament (teamname, winner, team_ID) 
        VALUES (?, ?, ?)
    `;

    connection.query(query, [teamOne, winnerTeam, 1], (err, result) => {
        if (err) {
            console.error('Error saving winner:', err);
            return res.status(500).json({ error: 'Error saving winner', details: err.message });
        }

        console.log('Game result saved:', result);
        res.status(200).json({ message: 'Game result saved', result });
    });
});

app.get('/getElo/:playername', (req, res) => {
    const { playername } = req.params;

    connection.query(
        'SELECT eloPoints FROM `player` WHERE `playername` = ?',
        [playername],
        (err, results) => {
            if (err) {
                console.error('Error fetching Elo:', err);
                res.status(500).send('Error fetching Elo');
                return;
            }

            if (results.length === 0) {
                res.status(404).send('Player not found');
                return;
            }

            res.json({ playername, eloPoints: results[0].eloPoints });
        }
    );
});

app.post('/updateElo', (req, res) => {
    const { winner, loser } = req.body;

    connection.query(
        'UPDATE `player` SET `eloPoints` = `eloPoints` + ? WHERE `playername` = ?',
        [elo, winner],
        err => {
            if (err) {
                console.error('Error updating winner Elo:', err);
                res.status(500).send('Error updating winner Elo');
                return;
            }

            // Decrease Elo for the loser
            connection.query(
                'UPDATE `player` SET `eloPoints` = `eloPoints` - ? WHERE `playername` = ?',
                [elo,loser],
                err => {
                    if (err) {
                        console.error('Error updating loser Elo:', err);
                        res.status(500).send('Error updating loser Elo');
                        return;
                    }

                    res.send('Elo points updated successfully');
                },
            );
        },
    );
});
// API-Endpoint to update a specific team
app.put('/updateTeam', (req, res) => {
    let {
        changedTeamname,
        changedDeletedValue,
        changedFirstMember,
        changedSecondMember,
        changedThirdMember,
        changedFourthMember,
        changedFifthMember,
        changedEloPoints,
        teamId,
    } = req.body;

    connection.query(
        'UPDATE `teams` SET `teamname` = ?, `deleted` = ?, `firstMember`= ?, `secondMember` = ?, `thirdMember` = ?, `fourthMember`= ?, `fifthMember`= ?, `eloPoints` = ? WHERE `teamID` = ?',
        [
            changedTeamname,
            changedDeletedValue,
            changedFirstMember,
            changedSecondMember,
            changedThirdMember,
            changedFourthMember,
            changedFifthMember,
            changedEloPoints,
            teamId,
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

// API-Endpoint to get player leaderboard data
app.get('/getPlayerLeaderboard', (req, res) => {
    connection.query('SELECT * FROM `player` WHERE `deleted` = 0 ORDER BY `eloPoints` DESC', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to get team leaderboard data
app.get('/getTeamLeaderboard', (req, res) => {
    connection.query(
        'SELECT * FROM `teams` WHERE `deleted` = 0 AND `firstMember` IS NOT NULL AND `secondMember` IS NOT NULL AND `thirdMember` IS NOT NULL AND `fourthMember` IS NOT NULL AND `fifthMember` IS NOT NULL  ORDER BY `eloPoints` DESC',
        (err, rows) => {
            if (err) {
                console.error(err);
            } else {
                res.json(rows);
            }
        },
    );
});
