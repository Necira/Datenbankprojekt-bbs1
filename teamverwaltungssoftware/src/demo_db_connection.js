let mysql = require('mysql');

let connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'Datenbankprojekt-BBS1',
});

connection.connect(function () {
    try {
        console.log('Connected!');
        var sqlQuerie =
            'INSERT INTO `player` (`playername`,`firstname`,`lastname`,`email`,`position`,`elo-points`) VALUES ("NoFPS","louis","lohmer","louis.lohmer@mediaman.de","top",1200);';
        connection.query(sqlQuerie, function (error) {
            if (error) {
                console.error(error);
            } else {
                console.log('Successfull databank operation!');
                connection.end();
            }
        });
    } catch (error) {
        console.error(error);
    }
});
