<template>
    <navigationBar></navigationBar>
    <h1>Edit existing player</h1>
    <div class="centered-column">
        <input
            type="text"
            id="searchfield"
            placeholder="search for position,playername..."
            @keyup="getFilteredPlayer"
        />
        <span class="resultMessage"> {{ resultMessage }}</span>
    </div>
        <div class="scrollable-container">
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
        </div>
    <button type="button" class="delete-player margin-right" @click="openAndCloseDeletePlayerPopUpWindow">
        Delete player
    </button>
    <button type="button" class="edit-player margin-right" @click="openAndCloseEditPlayerForm">
        Edit player
    </button>
    <RouterLink to="/PlayerSettings" class="back">← Back </RouterLink>

    <div v-if="openEditPlayerForm" class="popUp-Window position-edit-player-popup">
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
            <span class="success-message"> {{ successMessage }}</span>
            <span class="error-message">{{ errorMessage }}</span>
            <button type="button" class="edit-player" @click="validateEditPlayerForm">Edit player</button>
        </form>
    </div>

    <div class="popUp-Window position-delete-player-popup" v-if="openDeletePlayerPopUpWindow">
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
            <span class="success-message"> {{ successMessage }}</span>
            <button type="button" class="delete-player" @click="deletePlayer">Delete player</button>
        </div>
    </div>
    <footerBar></footerBar>
</template>

<script>
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components: {
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
                        document.getElementById('player-table').style.border = 'none';
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
                    document.getElementById('player-table').style.border = 'none';
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
    align-items: flex-start;
    flex-direction: column;
}

.error-message {
    color: var(--red);
    font-size: 20px;
}

.success-message {
    color: var(--green);
    font-size: 20px;
}

.popUp-Window {
    background-color: var(--white);
    border-radius: 12px;
    box-shadow: 0 4px 8px var(--transparentblack);
    max-width: 600px;
    padding: 15px;
}

.position-delete-player-popup {
    position: fixed;
    left: 45%;
    top: 40%;
}

.position-edit-player-popup {
    position: fixed;
    left: 45%;
    top: 5%;
}

.column {
    display: flex;
    align-items: flex-start;
    flex-direction: column;
}

.centered-column {
    display: flex;
    align-items: center;
    flex-direction: column;
    margin-bottom: 15px;
}

.close-PopUpWindow {
    display: flex;
    background: transparent;
    border: none;
    padding-bottom: 15px;
    cursor: pointer;
}

#player-table {
    margin: auto;
    margin-bottom: 15px;
    border-spacing: 10px 0;
    border: 2px solid var(--black);
    border-collapse: collapse;
}

.hidden {
    visibility: hidden;
}

.margin-right {
    margin-right: 20px;
}

#searchfield {
    width: 200px;
    padding: 5px;
}

label {
    margin-bottom: 8px;
    font-size: 16px;
    color: var(--black);
    font-weight: 500;
}

select,
input {
    padding: 5px;
    width: 85%;
    max-width: 250px;
    font-size: 16px;
    color: var(--black);
    border: 1px solid var(--lightgrey);
    border-radius: 8px;
    background-color: var(--white);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
    margin-bottom: 10px;
}

select:hover,
input:hover {
    border-color: var(--black);
}

select:focus,
input:focus {
    outline: none;
    border-color: var(--blue);
    box-shadow: 0 0 5px var(--transparentblue);
}

.delete-player,
.edit-player {
    display: inline-block;
    padding: 15px 25px;
    background-color: var(--darkgrey);
    color: var(--white);
    font-size: 16px;
    border: none;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px var(--transparentblack);
    text-transform: uppercase;
}

.delete-player:hover,
.edit-player:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

.back {
    font-size: 16px;
    color: var(--blue);
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: color 0.3s ease, transform 0.2s ease;
}

.back:hover {
    color: var(--hoverblue);
    transform: scale(1.05);
}

th,
td {
    border: 1px solid var(--black);
    padding: 5px;
}

tr:nth-of-type(even) {
    background-color: var(--lightgrey2);
}

thead {
    background-color: var(--hovergreen);
    border: 2px solid var(--black);
}

.scrollable-container {
    width: fit-content;
    overflow-y: scroll;
    margin: 0 auto;
    height: 380px;
}

/* Responsive Anpassungen für Tablets*/
@media only screen and (min-width: 768px) and (max-width: 1023px) {
    .position-delete-player-popup {
        left: 42%;
        top: 45%;
    }

    .position-edit-player-popup {
        left: 45%;
        top: 28%;
    }
}

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    h1 {
        font-size: 20px;
    }

    select,
    input {
        padding: 5px;
        font-size: 14px;
    }

    label {
        font-size: 15px;
    }

    .delete-player,
    .edit-player {
        padding: 10px 10px;
        font-size: 13px;
    }

    #player-table {
        font-size: 15px;
    }

    .scrollable-container {
        width: 300px;
        overflow-x: scroll;
        margin: 0 auto;
    }

    .position-delete-player-popup {
        left: 23%;
        top: 27%;
    }

    .position-edit-player-popup {
        left: 20%;
        top: 10%;
    }

    .error-message,
    .success-message {
        font-size: 15px;
    }

    .scrollable-container {
        width: 300px;
        overflow-x: scroll;
        height: fit-content;
    }
}
</style>
