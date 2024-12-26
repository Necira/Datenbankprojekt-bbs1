const express = require('express');
const mySql = require('mysql');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors());
app.listen(port, () => {
    // Databank must run in the background in order run server.js successfully
    console.log('server runs on http://localhost:' + port);
});

let connection = mySql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
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

// API-Endpoint to get all Player
app.get('/getPlayer', (req, res) => {
    connection.query('SELECT * FROM `player`', (err, rows) => {
        if (err) {
            console.error(err);
        } else {
            res.json(rows);
        }
    });
});

// API-Endpoint to update a specific player
app.put('/updatePlayer', (req, res) => {
    // TO-DO: write correct sql-querie and test it
    let {
        changedPlayername,
        changedFirstname,
        changedLastname,
        changedEmail,
        changedPosition,
        changedEloPoints,
        playerId,
    } = req.body;

    connection.query(
        'UPDATE `player` SET `playername` = ?, `firstname` = ?, `lastname`= ?, `email` = ?, `position` = ?, `eloPoints`= ? WHERE `playerID` = ?',
        [
            changedPlayername,
            changedFirstname,
            changedLastname,
            changedEmail,
            changedPosition,
            changedEloPoints,
            playerId,
        ],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send('User updated successfully');
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
                res.send('User updated successfully');
            }
        },
    );
});

// API-Endpoint to create new team
app.post('/createNewTeam', (req, res) => {
    let { newTeamname, newEloPoints } = req.body;
    connection.query(
        'INSERT INTO `teams` (`teamname`, `eloPoints`) VALUES (?, ?)',
        [newTeamname, newEloPoints],
        (err, result) => {
            if (err) {
                console.error(err);
            } else {
                res.send(req.body);
            }
        },
    );
});
