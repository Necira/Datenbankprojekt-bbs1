<template>
    <navigationBar></navigationBar>
    <h1>Edit existing player</h1>
    <div class="column">
        <input
            type="text"
            id="searchfield"
            placeholder="search for position,playername..."
            @keyup="getFilteredPlayer"
        />
        <span class="resultMessage"> {{ resultMessage }}</span>
    </div>
    <table id="player-table">
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
        <tbody>
            <tr v-for="row in fetchedPlayerdata" :key="row">
                <td>{{ row.playerID }}</td>
                <td>{{ row.playername }}</td>
                <td>{{ row.firstname }}</td>
                <td>{{ row.lastname }}</td>
                <td>{{ row.email }}</td>
                <td>{{ row.position }}</td>
                <td>{{ row.eloPoints }}</td>
                <td>{{ row.deleted }}</td>
            </tr>
        </tbody>
    </table>
    <button type="button" @click="openAndCloseDeletePlayerPopUpWindow">Delete player</button>
    <button type="button" @click="openAndCloseEditPlayerForm">Edit player</button>
    <RouterLink to="/PlayerSettings" class="back">← Back </RouterLink>

    <div v-if="openEditPlayerForm" class="popUp-Window">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseEditPlayerForm">X</button>
        <form class="edit-player-form">
            <label for="selectPlayerID">PlayerID:</label>
            <select id="selectPlayerID" name="selectPlayerID">
                <option v-for="player in editablePlayer" :key="player" :id="player">{{ player }}</option>
            </select>
            <label for="playername">Playername:</label>
            <input id="playername" name="playername" />
            <label for="firstname">firstname:</label>
            <input type="text" id="firstname" name="firstname" />
            <label for="lastname">lastname:</label>
            <input type="text" id="lastname" name="lastname" />
            <label for="email">E-Mail:</label>
            <input type="email" id="email" name="email" />
            <label for="position">Position:</label>
            <select id="position" name="position">
                <option value="Top-Lane">Top-Lane</option>
                <option value="Jungle">Jungle</option>
                <option value="Mid-lane">Mid-lane</option>
                <option value="Bot-Lane">Bot-Lane</option>
                <option value="Support">Support</option>
            </select>
            <label for="eloPoints">Elo-Points:</label>
            <input type="number" min="0" max="4000" id="eloPoints" name="eloPoints" />
            <label for="deleted">deleted:</label>
            <input type="number" min="0" max="1" id="deleted" name="deleted" />
            <button type="button" @click="validateEditPlayerForm">Edit player</button>
        </form>
        <span class="success-message"> {{ successMessage }}</span>
        <span class="error-message">{{ errorMessage }}</span>
    </div>

    <div class="popUp-Window" v-if="openDeletePlayerPopUpWindow">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseDeletePlayerPopUpWindow">
            X
        </button>
        <div class="column">
            <label for="SelectPlayername">Chosse a player:</label>
            <select id="SelectPlayername" name="SelectPlayername">
                <option v-for="player in deleteablePlayer" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <button type="button" @click="deletePlayer">Delete player</button>
        </div>
        <span class="success-message"> {{ successMessage }}</span>
    </div>
    <footerBar></footerBar>
</template>

<script>
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components:{
        navigationBar,
        footerBar,
    },
    data() {
        return {
            name: 'EditPlayer',
            errorMessage: '',
            successMessage: '',
            resultMessage: '',
            openDeletePlayerPopUpWindow: false,
            openEditPlayerForm: false,
            deleteablePlayer: [],
            editablePlayer: [],
            fetchedPlayerdata: [],
        };
    },
    methods: {
        deletePlayer() {
            let selectElement = document.getElementById('SelectPlayername');
            let playerId = selectElement.options[selectElement.selectedIndex].id;

            fetch('http://localhost:3000/deletePlayer', {
                method: 'PATCH',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    deletedPlayerId: playerId,
                    valueDeleted: 1,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        this.displayPlayerTable();
                        this.successMessage = 'deleted player successfully!';
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
            this.successMessage = '';
            this.deleteablePlayer = [];

            if (this.openDeletePlayerPopUpWindow) {
                fetch('http://localhost:3000/getActivePlayer')
                    .then(response => response.json())
                    .then(data => {
                        // Display all available player-IDs in the select-option-field
                        this.deleteablePlayer = data.map(player => ({
                            id: player.playerID,
                            name: player.playername,
                        }));
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        openAndCloseEditPlayerForm() {
            this.openEditPlayerForm = !this.openEditPlayerForm;
            this.successMessage = '';
            this.editablePlayer = [];

            if (this.openEditPlayerForm) {
                fetch('http://localhost:3000/getPlayer')
                    .then(response => response.json())
                    .then(data => {
                        // Display all available player-IDs in the select-option-field
                        this.editablePlayer = data.map(player => player.playerID);
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        validateEditPlayerForm() {
            let selectElement = document.getElementById('selectPlayerID');
            let playerId = selectElement.options[selectElement.selectedIndex].id;
            let playername = document.getElementById('playername').value;
            let firstname = document.getElementById('firstname').value;
            let lastname = document.getElementById('lastname').value;
            let email = document.getElementById('email').value;
            let selectElement2 = document.getElementById('position');
            let position = selectElement2.options[selectElement2.selectedIndex].value;
            let eloPoints = document.getElementById('eloPoints').value;
            let deleted = document.getElementById('deleted').value;

            if (
                deleted.length === 0 ||
                playername.length === 0 ||
                firstname.length === 0 ||
                lastname.length === 0 ||
                email.length === 0 ||
                eloPoints.length === 0
            ) {
                this.errorMessage = 'Please fill out at least one form field!';
                return;
            } else {
                this.errorMessage = '';
            }

            if (eloPoints > 4000) {
                this.errorMessage = 'Maximum Elo-Points are 4000';
                return;
            } else {
                this.errorMessage = '';
            }

            if (firstname.length > 0) {
                let splittedFirstname = firstname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedFirstname.length; i++) {
                    if (!splittedFirstname[i].match(onlyLettersRegEx)) {
                        this.errorMessage = 'Invalid firstname!';
                        return;
                    }
                }
            } else {
                this.errorMessage = '';
            }

            if (lastname.length > 0) {
                let splittedLastname = lastname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedLastname.length; i++) {
                    if (!splittedLastname[i].match(onlyLettersRegEx)) {
                        this.errorMessage = 'Invalid lastname!';
                        return;
                    }
                }
            } else {
                this.errorMessage = '';
            }

            if (email.length > 0) {
                const regExEmail = /^[a-z0-9.]+@[a-z]+\.[a-z]{2,4}$/;
                if (!email.match(regExEmail)) {
                    this.errorMessage = 'Invalid E-mail!';
                    return;
                }
            } else {
                this.errorMessage = '';
            }

            if (playername.length > 0) {
                for (let i = 0; i < this.fetchedPlayerdata.length; i++) {
                    if (
                        this.fetchedPlayerdata[i].playername === playername &&
                        this.fetchedPlayerdata[i].playerID === Number(playerId)
                    ) {
                        this.errorMessage = '';
                        break;
                    } else if (
                        this.fetchedPlayerdata[i].playername === playername &&
                        this.fetchedPlayerdata[i].playerID !== Number(playerId)
                    ) {
                        this.errorMessage = 'Playername already exists!';
                        return;
                    }
                }
            } else {
                this.errorMessage = '';
            }

            this.updateExistingPlayer(
                playername,
                firstname,
                lastname,
                email,
                position,
                eloPoints,
                deleted,
                playerId,
            );
        },
        async updateExistingPlayer(
            setPlayername,
            setFirstname,
            setLastname,
            setEmail,
            setPosition,
            setEloPoints,
            setDeleted,
            setPlayerId,
        ) {
            fetch('http://localhost:3000/updatePlayer', {
                method: 'PUT',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    changedPlayername: setPlayername,
                    changedFirstname: setFirstname,
                    changedLastname: setLastname,
                    changedEmail: setEmail,
                    changedPosition: setPosition,
                    changedEloPoints: setEloPoints,
                    changedDeletedValue: setDeleted,
                    playerId: setPlayerId,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        this.displayPlayerTable();
                        this.successMessage = 'updated player successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        displayPlayerTable() {
            this.fetchedPlayerdata = [];

            fetch('http://localhost:3000/getPlayer')
                .then(response => response.json())
                .then(data => {
                    if (data.length === 0) {
                        document.getElementById('player-table').innerHTML = 'No data available!';
                    }

                    // Display fetched data in the table above
                    this.fetchedPlayerdata = data.map(player => ({
                        playerID: player.playerID,
                        playername: player.playername,
                        firstname: player.firstname,
                        lastname: player.lastname,
                        email: player.email,
                        position: player.position,
                        eloPoints: player.eloPoints,
                        deleted: player.deleted,
                    }));
                })
                .catch(error => {
                    console.error(error);
                    document.getElementById('player-table').innerHTML = 'No data available!';
                    return;
                });
        },
        getFilteredPlayer() {
            let searchvalue = document.getElementById('searchfield').value;
            let playerTable = document.getElementById('player-table');
            let tbodyPlayerTable = playerTable.childNodes[1];
            let tbodyRows = tbodyPlayerTable.childNodes;
            let counterDisplayedRows = 0;

            if (searchvalue.length === 0) {
                this.resultMessage = '';

                for (let i = 1; i <= this.fetchedPlayerdata.length; i++) {
                    tbodyRows[i].classList.remove('hidden');
                }
            } else {
                for (let i = 1; i <= this.fetchedPlayerdata.length; i++) {
                    let currentRow = tbodyRows[i];

                    for (let i = 0; i < currentRow.cells.length; i++) {
                        let currentTableDataCell = currentRow.cells[i];

                        if (currentTableDataCell.innerHTML.toLowerCase() !== searchvalue.toLowerCase()) {
                            currentRow.classList.add('hidden');
                        } else {
                            counterDisplayedRows++;
                            currentRow.classList.remove('hidden');
                            break;
                        }
                    }
                }

                this.resultMessage =
                    'Found ' + counterDisplayedRows + ' datasets that matches ' + searchvalue;
            }
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

#player-table {
    margin: auto;
}

.hidden {
    visibility: hidden;
}

#searchfield {
    width: 200px;
}

.back {
    font-size: 16px;
    color: #007bff;
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: color 0.3s ease, transform 0.2s ease;
}

.back:hover {
    color: #0056b3;
    transform: scale(1.05);
}
</style>
