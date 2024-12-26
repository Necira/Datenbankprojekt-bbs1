<template>
    <h1>Edit existing player</h1>
    <table class="player-table">
        <thead>
            <tr>
                <th>playerID</th>
                <th>playername</th>
                <th>firstname</th>
                <th>lastname</th>
                <th>email</th>
                <th>position</th>
                <th>eloPoints</th>
                <th>deleted</th>
            </tr>
        </thead>
        <tbody id="tbody-player-table"></tbody>
    </table>
    <button type="button" @click="openAndCloseDeletePlayerPopUpWindow">Delete player</button>
    <button type="button" @click="openAndCloseEditPlayerForm">Edit player</button>
    <RouterLink to="/PlayerSettings"> Back </RouterLink>

    <div v-if="openEditPlayerForm" class="popUp-Window">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseEditPlayerForm">X</button>
        <form class="edit-player-form">
            <label for="selectPlayerID">PlayerID:</label>
            <select id="selectPlayerID" name="selectPlayerID"></select>
            <label for="playername">Playername:</label>
            <input id="playername" name="playername" />
            <label for="firstname">firstname:</label>
            <input type="text" id="firstname" name="firstname" />
            <label for="lastname">lastname:</label>
            <input type="text" id="lastname" name="lastname" />
            <label for="email">E-Mail:</label>
            <input type="email" id="email" name="email" />
            <label for="position">Position:</label>
            <input type="text" id="position" name="position" />
            <label for="eloPoints">Elo-Points:</label>
            <input type="number" min="0" id="eloPoints" name="eloPoints" />
            <label for="deleted">deleted:</label>
            <input type="number" min="0" max="1" id="deleted" name="deleted" />
            <button type="button" @click="editPlayer">Edit player</button>
        </form>
        <span class="success-message"> {{ textSuccessMessage }}</span>
        <span class="error-message">{{ textErrorMessage }}</span>
    </div>

    <div class="popUp-Window" v-if="openDeletePlayerPopUpWindow">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseDeletePlayerPopUpWindow">
            X
        </button>
        <div class="column">
            <label for="SelectPlayername">Chosse a player:</label>
            <select id="SelectPlayername" name="SelectPlayername"></select>
            <button type="button" @click="deletePlayer">Delete player</button>
        </div>
        <span class="success-message"> {{ textSuccessMessage }}</span>
    </div>
</template>

<script>
export default {
    data() {
        return {
            name: 'EditPlayer',
            textErrorMessage: '',
            textSuccessMessage: '',
            openDeletePlayerPopUpWindow: false,
            openEditPlayerForm: false,
        };
    },
    methods: {
        deletePlayer() {
            let selectElement = document.getElementById('SelectPlayername');
            let idSelectedOption = selectElement.options[selectElement.selectedIndex].id;

            // Start server.js and databank for a functional patch-request
            fetch('http://localhost:3000/deletePlayer', {
                method: 'PATCH',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    deletedPlayerId: idSelectedOption,
                    valueDeleted: 1,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        // Update table in frontend after new changes
                        this.displayPlayerTable();
                        this.textSuccessMessage = 'deleted player successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        openAndCloseDeletePlayerPopUpWindow() {
            this.openDeletePlayerPopUpWindow = !this.openDeletePlayerPopUpWindow;
            this.textSuccessMessage = '';

            /** Start server.js and databank for a functional post-request
             *  Display all available player-IDs in the select-option-field
             */
            if (this.openDeletePlayerPopUpWindow) {
                fetch('http://localhost:3000/getActivePlayer')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            let newPlayerOption = document.createElement('option');
                            newPlayerOption.innerHTML = data[i].playername;
                            newPlayerOption.id = data[i].playerID;

                            document.getElementById('SelectPlayername').appendChild(newPlayerOption);
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        openAndCloseEditPlayerForm() {
            this.openEditPlayerForm = !this.openEditPlayerForm;
            this.textSuccessMessage = '';

            if (this.openEditPlayerForm) {
                /** Start server.js and databank for a functional post-request
                 *  Display all available player in the select-option-field
                 */
                fetch('http://localhost:3000/getPlayer')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            let playerOption = document.createElement('option');
                            playerOption.innerHTML = data[i].playerID;
                            playerOption.id = data[i].playerID;

                            document.getElementById('selectPlayerID').appendChild(playerOption);
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        editPlayer() {
            let selectElement = document.getElementById('selectPlayerID');
            let idSelectedOption = selectElement.options[selectElement.selectedIndex].id;
            let playername = document.getElementById('playername').value;
            let firstname = document.getElementById('firstname').value;
            let lastname = document.getElementById('lastname').value;
            let email = document.getElementById('email').value;
            let position = document.getElementById('position').value;
            let eloPoints = document.getElementById('eloPoints').value;
            let deleted = document.getElementById('deleted').value;

            if (
                deleted.length === 0 ||
                playername.length === 0 ||
                firstname.length === 0 ||
                lastname.length === 0 ||
                email.length === 0 ||
                position.length === 0 ||
                eloPoints.length === 0
            ) {
                this.textErrorMessage = 'Please fill out at least one form field!';
                return;
            } else {
                this.textErrorMessage = '';
            }

            if (firstname.length > 0) {
                let splittedFirstname = firstname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedFirstname.length; i++) {
                    if (!splittedFirstname[i].match(onlyLettersRegEx)) {
                        this.textErrorMessage = 'Invalid firstname!';
                        return;
                    }
                }
            } else {
                this.textErrorMessage = '';
            }

            if (lastname.length > 0) {
                let splittedLastname = lastname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedLastname.length; i++) {
                    if (!splittedLastname[i].match(onlyLettersRegEx)) {
                        this.textErrorMessage = 'Invalid lastname!';
                        return;
                    }
                }
            } else {
                this.textErrorMessage = '';
            }

            if (email.length > 0) {
                const regExEmail = /^[a-z0-9.]+@[a-z]+\.[a-z]{2,4}$/;
                if (!email.match(regExEmail)) {
                    this.textErrorMessage = 'Invalid E-mail!';
                    return;
                }
            } else {
                this.textErrorMessage = '';
            }

            // Start server.js and databank for a functional put-request
            fetch('http://localhost:3000/updatePlayer', {
                method: 'PUT',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    changedPlayername: playername,
                    changedFirstname: firstname,
                    changedLastname: lastname,
                    changedEmail: email,
                    changedPosition: position,
                    changedEloPoints: eloPoints,
                    changedDeletedValue: deleted,
                    playerId: idSelectedOption,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        // display new changes in player table
                        this.displayPlayerTable();
                        this.textSuccessMessage = 'updated player successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        displayPlayerTable() {
            document.getElementById('tbody-player-table').innerHTML = '';

            // Start server.js and databank for a functional get-request
            fetch('http://localhost:3000/getPlayer')
                .then(response => response.json())
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        let newTableRow = document.createElement('tr');

                        let tableDataCellID = document.createElement('td');
                        tableDataCellID.innerHTML = data[i].playerID;
                        newTableRow.appendChild(tableDataCellID);

                        let tableDataCellPlayername = document.createElement('td');
                        tableDataCellPlayername.innerHTML = data[i].playername;
                        newTableRow.appendChild(tableDataCellPlayername);

                        let tableDataCellFirstname = document.createElement('td');
                        tableDataCellFirstname.innerHTML = data[i].firstname;
                        newTableRow.appendChild(tableDataCellFirstname);

                        let tableDataCellLastname = document.createElement('td');
                        tableDataCellLastname.innerHTML = data[i].lastname;
                        newTableRow.appendChild(tableDataCellLastname);

                        let tableDataCellEmail = document.createElement('td');
                        tableDataCellEmail.innerHTML = data[i].email;
                        newTableRow.appendChild(tableDataCellEmail);

                        let tableDataCellPosition = document.createElement('td');
                        tableDataCellPosition.innerHTML = data[i].position;
                        newTableRow.appendChild(tableDataCellPosition);

                        let tableDataCellEloPoints = document.createElement('td');
                        tableDataCellEloPoints.innerHTML = data[i].eloPoints;
                        newTableRow.appendChild(tableDataCellEloPoints);

                        let tableDataCellDeleted = document.createElement('td');
                        tableDataCellDeleted.innerHTML = data[i].deleted;
                        newTableRow.appendChild(tableDataCellDeleted);

                        document.getElementById('tbody-player-table').appendChild(newTableRow);
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
    },
    mounted() {
        // call function, when component is created
        this.displayPlayerTable();
    },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.edit-player-form {
    display: flex;
    justify-content: center;
    flex-direction: column;
}

.error-message {
    color: red;
    font-size: 20px;
}

.success-message {
    color: green;
    font-size: 20px;
}

.popUp-Window {
    background-color: aquamarine;
    padding: 15px;
    position: fixed;
    margin: auto 0;
    left: 45%;
    top: 25%;
}

.column {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.close-PopUpWindow {
    display: flex;
}

.player-table {
    margin: auto;
}
</style>
