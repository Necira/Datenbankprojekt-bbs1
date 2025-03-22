<template>
    <navigationBar></navigationBar>
    <h1>Edit existing team</h1>
    <div class="centered-column">
        <input
            type="text"
            id="searchfield"
            placeholder="search for position,teamname..."
            @keyup="getFilteredTeam"
        />
        <span class="resultMessage"> {{ resultMessage }}</span>
    </div>
    <div class="scrollable-container">
        <table id="teams-table">
            <thead>
                <tr>
                    <th>teamID</th>
                    <th>teamname</th>
                    <th>eloPoints</th>
                    <th>deleted</th>
                    <th>Top-Lane</th>
                    <th>Jungle</th>
                    <th>Mid-Lane</th>
                    <th>Support</th>
                    <th>Bot-Lane</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="row in fetchedTeamdata" :key="row">
                    <td>{{ row.teamID }}</td>
                    <td>{{ row.teamname }}</td>
                    <td>{{ row.eloPoints }}</td>
                    <td>{{ row.deleted }}</td>
                    <td>{{ row.firstMember }}</td>
                    <td>{{ row.secondMember }}</td>
                    <td>{{ row.thirdMember }}</td>
                    <td>{{ row.fourthMember }}</td>
                    <td>{{ row.fifthMember }}</td>
                </tr>
            </tbody>
        </table>
    </div>
    <button type="button" @click="openAndCloseDeleteTeamPopUpWindow" class="delete-team margin-right">
        Delete team
    </button>
    <button type="button" @click="openAndCloseEditTeamForm" class="edit-team margin-right">Edit team</button>
    <RouterLink to="/TeamSettings" class="back">← Back </RouterLink>

    <div class="popUp-Window position-delete-player-popup" v-if="openDeleteTeamPopUpWindow">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseDeleteTeamPopUpWindow">X</button>
        <div class="column">
            <label for="selectTeamname">Choose a team:</label>
            <select id="selectTeamname" name="selectTeamname">
                <option v-for="team in deleteableTeams" :key="team" :id="team.id">{{ team.name }}</option>
            </select>
            <span class="success-message"> {{ successMessage }}</span>
            <button type="button" @click="deleteTeam" class="delete-team">Delete team</button>
        </div>
    </div>

    <div v-if="openEditTeamForm" class="popUp-Window position-edit-player-popup">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseEditTeamForm">X</button>
        <form class="edit-team-form">
            <label for="selectTeamID">TeamID:</label>
            <select id="selectTeamID" name="selectTeamID">
                <option v-for="team in editableTeams" :key="team" :id="team">{{ team }}</option>
            </select>
            <label for="teamname">teamname:</label>
            <input id="teamname" name="teamname" />
            <label for="deleted">deleted:</label>
            <input type="number" min="0" max="1" id="deleted" name="deleted" />
            <label for="firstMember">Top-Lane:</label>
            <select id="firstMember" name="firstMember">
                <option id="NULL">No player</option>
                <option v-for="player in availablePlayerTopLane" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="secondMember">Jungle:</label>
            <select id="secondMember" name="secondMember">
                <option id="NULL">No player</option>
                <option v-for="player in availablePlayerJungle" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="thirdMember">Mid-Lane:</label>
            <select id="thirdMember" name="thirdMember">
                <option id="NULL">No player</option>
                <option v-for="player in availablePlayerMidLane" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="fourthMember">Support:</label>
            <select id="fourthMember" name="fourthMember">
                <option id="NULL">No player</option>
                <option v-for="player in availablePlayerSupport" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="fifthMember">Bot-Lane:</label>
            <select id="fifthMember" name="fifthMember">
                <option id="NULL">No player</option>
                <option v-for="player in availablePlayerBotLane" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>

            <span class="success-message"> {{ successMessage }}</span>
            <span class="error-message">{{ errorMessage }}</span>
            <button type="button" @click="validateEditTeamForm" class="edit-team">Edit team</button>
        </form>
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
            name: 'EditTeam',
            openDeleteTeamPopUpWindow: false,
            openEditTeamForm: false,
            successMessage: '',
            errorMessage: '',
            resultMessage: '',
            deleteableTeams: [],
            availablePlayerTopLane: [],
            availablePlayerMidLane: [],
            availablePlayerBotLane: [],
            availablePlayerSupport: [],
            availablePlayerJungle: [],
            editableTeams: [],
            fetchedTeamdata: [],
        };
    },
    methods: {
        displayTeamsdata() {
            let playerData = [];

            fetch('http://localhost:3000/getPlayer')
                .then(response => response.json())
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        playerData.push({ id: data[i].playerID, name: data[i].playername });
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });

            fetch('http://localhost:3000/getTeams')
                .then(response => response.json())
                .then(data => {
                    this.fetchedTeamdata = [];

                    if (data.length === 0) {
                        document.getElementById('teams-table').innerHTML = 'No data available!';
                        document.getElementById('teams-table').style.border = 'none';
                    }

                    for (let i = 0; i < data.length; i++) {
                        for (let a = 0; a < playerData.length; a++) {
                            // Display fetched data in the select-option-fields above
                            if (data[i].firstMember === null) {
                                data[i].firstMember = 'NULL';
                            } else if (playerData[a].id === data[i].firstMember) {
                                data[i].firstMember = playerData[a].name;
                            }

                            if (data[i].secondMember === null) {
                                data[i].secondMember = 'NULL';
                            } else if (playerData[a].id === data[i].secondMember) {
                                data[i].secondMember = playerData[a].name;
                            }

                            if (data[i].thirdMember === null) {
                                data[i].thirdMember = 'NULL';
                            } else if (playerData[a].id === data[i].thirdMember) {
                                data[i].thirdMember = playerData[a].name;
                            }

                            if (data[i].fourthMember === null) {
                                data[i].fourthMember = 'NULL';
                            } else if (playerData[a].id === data[i].fourthMember) {
                                data[i].fourthMember = playerData[a].name;
                            }

                            if (data[i].fifthMember === null) {
                                data[i].fifthMember = 'NULL';
                            } else if (playerData[a].id === data[i].fifthMember) {
                                data[i].fifthMember = playerData[a].name;
                            }
                        }

                        this.fetchedTeamdata.push({
                            teamID: data[i].teamID,
                            teamname: data[i].teamname,
                            eloPoints: data[i].eloPoints,
                            deleted: data[i].deleted,
                            firstMember: data[i].firstMember,
                            secondMember: data[i].secondMember,
                            thirdMember: data[i].thirdMember,
                            fourthMember: data[i].fourthMember,
                            fifthMember: data[i].fifthMember,
                        });
                    }
                })
                .catch(error => {
                    console.error(error);
                    document.getElementById('teams-table').innerHTML = 'No data available!';
                    document.getElementById('teams-table').style.border = 'none';
                    return;
                });
        },
        openAndCloseDeleteTeamPopUpWindow() {
            this.openDeleteTeamPopUpWindow = !this.openDeleteTeamPopUpWindow;
            this.successMessage = '';

            if (this.openDeleteTeamPopUpWindow) {
                this.deleteableTeams = [];

                fetch('http://localhost:3000/getActiveTeams')
                    .then(response => response.json())
                    .then(data => {
                        // Display fetched data in the table above
                        this.deleteableTeams = data.map(team => ({
                            id: team.teamID,
                            name: team.teamname,
                        }));
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        openAndCloseEditTeamForm() {
            this.openEditTeamForm = !this.openEditTeamForm;
            this.successMessage = '';
            this.errorMessage = '';

            if (this.openEditTeamForm) {
                this.availablePlayerBotLane = [];
                this.availablePlayerJungle = [];
                this.availablePlayerMidLane = [];
                this.availablePlayerSupport = [];
                this.availablePlayerTopLane = [];
                this.editableTeams = [];

                fetch('http://localhost:3000/getTeams')
                    .then(response => response.json())
                    .then(data => {
                        // Display fetched data in the select-option-field above
                        this.editableTeams = data.map(team => team.teamID);
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });

                fetch('http://localhost:3000/getActivePlayer')
                    .then(response => response.json())
                    .then(activePlayerData => {
                        let activePlayer = activePlayerData.map(data => ({
                            id: data.playerID,
                            name: data.playername,
                            position: data.position,
                        }));

                        fetch('http://localhost:3000/getActiveTeammember')
                            .then(response => response.json())
                            .then(activeTeammemberData => {
                                let activeTeammember = activeTeammemberData.map(data => ({
                                    id: data.playerID,
                                    name: data.playername,
                                }));

                                let availableTeammember = [];
                                for (let i = 0; i < activeTeammember.length; i++) {
                                    for (let a = 0; a < activePlayer.length; a++) {
                                        if (
                                            activeTeammember[i].id !== activePlayer[a].id &&
                                            !availableTeammember.some(
                                                element =>
                                                    element.id === activePlayer[a].id &&
                                                    element.name === activePlayer[a].name,
                                            ) &&
                                            !activeTeammember.some(
                                                element =>
                                                    element.id === activePlayer[a].id &&
                                                    element.name === activePlayer[a].name,
                                            )
                                        ) {
                                            availableTeammember.push({
                                                id: activePlayer[a].id,
                                                name: activePlayer[a].name,
                                                position: activePlayer[a].position,
                                            });
                                        }
                                    }
                                }

                                // Display not deleted player, that are not in a team yet, in select-option-field
                                if (availableTeammember.length > 0 && activeTeammember.length > 0) {
                                    for (let i = 0; i < availableTeammember.length; i++) {
                                        if (availableTeammember[i].position === 'Top-Lane') {
                                            this.availablePlayerTopLane.push({
                                                id: availableTeammember[i].id,
                                                name: availableTeammember[i].name,
                                            });
                                        }

                                        if (availableTeammember[i].position === 'Jungle') {
                                            this.availablePlayerJungle.push({
                                                id: availableTeammember[i].id,
                                                name: availableTeammember[i].name,
                                            });
                                        }

                                        if (availableTeammember[i].position === 'Mid-lane') {
                                            this.availablePlayerMidLane.push({
                                                id: availableTeammember[i].id,
                                                name: availableTeammember[i].name,
                                            });
                                        }

                                        if (availableTeammember[i].position === 'Bot-Lane') {
                                            this.availablePlayerBotLane.push({
                                                id: availableTeammember[i].id,
                                                name: availableTeammember[i].name,
                                            });
                                        }

                                        if (availableTeammember[i].position === 'Support') {
                                            this.availablePlayerSupport.push({
                                                id: availableTeammember[i].id,
                                                name: availableTeammember[i].name,
                                            });
                                        }
                                    }
                                } else if (activeTeammember.length === 0) {
                                    for (let i = 0; i < activePlayer.length; i++) {
                                        if (activePlayer[i].position === 'Top-Lane') {
                                            this.availablePlayerTopLane.push({
                                                id: activePlayer[i].id,
                                                name: activePlayer[i].name,
                                            });
                                        }

                                        if (activePlayer[i].position === 'Jungle') {
                                            this.availablePlayerJungle.push({
                                                id: activePlayer[i].id,
                                                name: activePlayer[i].name,
                                            });
                                        }

                                        if (activePlayer[i].position === 'Mid-lane') {
                                            this.availablePlayerMidLane.push({
                                                id: activePlayer[i].id,
                                                name: activePlayer[i].name,
                                            });
                                        }

                                        if (activePlayer[i].position === 'Bot-Lane') {
                                            this.availablePlayerBotLane.push({
                                                id: activePlayer[i].id,
                                                name: activePlayer[i].name,
                                            });
                                        }

                                        if (activePlayer[i].position === 'Support') {
                                            this.availablePlayerSupport.push({
                                                id: activePlayer[i].id,
                                                name: activePlayer[i].name,
                                            });
                                        }
                                    }
                                }
                            })
                            .catch(error => {
                                console.error(error);
                                return;
                            });
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        deleteTeam() {
            let selectElement = document.getElementById('selectTeamname');
            let idSelectedOption = selectElement.options[selectElement.selectedIndex].id;

            fetch('http://localhost:3000/deleteTeam', {
                method: 'PATCH',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    deletedTeamID: idSelectedOption,
                    valueDeleted: 1,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        this.displayTeamsdata();
                        this.successMessage = 'deleted team successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        validateEditTeamForm() {
            this.successMessage = '';

            let selectFieldTeamId = document.getElementById('selectTeamID');
            let teamId = selectFieldTeamId.options[selectFieldTeamId.selectedIndex].id;
            let teamname = document.getElementById('teamname').value;
            let deleted = document.getElementById('deleted').value;
            let selectFieldFirstMember = document.getElementById('firstMember');
            let firstMember = Number(selectFieldFirstMember.options[selectFieldFirstMember.selectedIndex].id);
            let selectFieldSecondMember = document.getElementById('secondMember');
            let secondMember = Number(
                selectFieldSecondMember.options[selectFieldSecondMember.selectedIndex].id,
            );
            let selectFieldThirdMember = document.getElementById('thirdMember');
            let thirdMember = Number(selectFieldThirdMember.options[selectFieldThirdMember.selectedIndex].id);
            let selectFieldFourthMember = document.getElementById('fourthMember');
            let fourthMember = Number(
                selectFieldFourthMember.options[selectFieldFourthMember.selectedIndex].id,
            );
            let selectFieldFifthMember = document.getElementById('fifthMember');
            let fifthMember = Number(selectFieldFifthMember.options[selectFieldFifthMember.selectedIndex].id);

            if (teamname.length === 0 || deleted.length === 0) {
                this.errorMessage = 'Please fill out at least one form field!';
                return;
            } else {
                this.errorMessage = '';
            }

            if (Number(deleted) === 0 || Number(deleted) === 1) {
                this.errorMessage = '';
            } else {
                this.errorMessage = 'Invalid Value!';
                return;
            }

            if (
                firstMember === secondMember ||
                firstMember === thirdMember ||
                firstMember === fourthMember ||
                firstMember === fifthMember ||
                secondMember === thirdMember ||
                secondMember === fourthMember ||
                secondMember === fifthMember ||
                thirdMember === fourthMember ||
                thirdMember === fifthMember ||
                fourthMember === fifthMember
            ) {
                this.errorMessage = 'Cannot add the same player twice!';
                return;
            } else {
                this.errorMessage = '';
            }

            if (teamname.length > 0) {
                for (let i = 0; i < this.fetchedTeamdata.length; i++) {
                    if (
                        this.fetchedTeamdata[i].teamname === teamname &&
                        this.fetchedTeamdata[i].teamID === Number(teamId)
                    ) {
                        this.errorMessage = '';
                        break;
                    } else if (
                        this.fetchedTeamdata[i].teamname === teamname &&
                        this.fetchedTeamdata[i].teamID !== Number(teamId)
                    ) {
                        this.errorMessage = 'Teamname already exists!';
                        return;
                    }
                }
            } else {
                this.errorMessage = '';
            }

            this.updateExistingTeam(
                teamname,
                deleted,
                firstMember,
                secondMember,
                thirdMember,
                fourthMember,
                fifthMember,
                teamId,
            );
        },
        async updateExistingTeam(
            setTeamname,
            setDeleted,
            setFirstMember,
            setSecondMember,
            setThirdMember,
            setFourthMember,
            setFifthMember,
            setTeamId,
        ) {
            let eloPointsTeam = 0;
            let choosenTeamMembers = [
                setFirstMember,
                setSecondMember,
                setThirdMember,
                setFourthMember,
                setFifthMember,
            ];

            if (
                !isNaN(setFirstMember) &&
                !isNaN(setSecondMember) &&
                !isNaN(setThirdMember) &&
                !isNaN(setFourthMember) &&
                !isNaN(setFifthMember)
            ) {
                // Calculate Elo-Points, if team is complete
                eloPointsTeam = await fetch('http://localhost:3000/getPlayer')
                    .then(response => response.json())
                    .then(data => {
                        let calculatedEloPoints = 0;
                        for (let i = 0; i < choosenTeamMembers.length; i++) {
                            for (let a = 0; a < data.length; a++) {
                                if (choosenTeamMembers[i] === data[a].playerID) {
                                    calculatedEloPoints += data[a].eloPoints;
                                }
                            }
                        }

                        let finalEloPoints = Math.round(calculatedEloPoints / 5);
                        return finalEloPoints;
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            } else {
                eloPointsTeam++;
            }

            fetch('http://localhost:3000/updateTeam', {
                method: 'PUT',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    changedTeamname: setTeamname,
                    changedDeletedValue: setDeleted,
                    changedFirstMember: setFirstMember,
                    changedSecondMember: setSecondMember,
                    changedThirdMember: setThirdMember,
                    changedFourthMember: setFourthMember,
                    changedFifthMember: setFifthMember,
                    changedEloPoints: eloPointsTeam,
                    teamId: setTeamId,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        this.displayTeamsdata();
                        this.successMessage = 'updated team successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });

            this.openAndCloseEditTeamForm();
        },
        getFilteredTeam() {
            let searchvalue = document.getElementById('searchfield').value;
            let tableTeams = document.getElementById('teams-table');
            let tbodyElement = tableTeams.childNodes[1];
            let tbodyRows = tbodyElement.childNodes;
            let counterDisplayedRows = 0;

            if (searchvalue.length === 0) {
                this.resultMessage = '';

                for (let i = 1; i <= this.fetchedTeamdata.length; i++) {
                    tbodyRows[i].classList.remove('hidden');
                }
            } else {
                for (let i = 1; i <= this.fetchedTeamdata.length; i++) {
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
        this.displayTeamsdata();
    },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#teams-table {
    margin: auto;
    margin-bottom: 15px;
    border-spacing: 10px 0;
    border: 2px solid var(--black);
    border-collapse: collapse;
}

.success-message {
    color: var(--green);
    font-size: 20px;
}

.error-message {
    color: var(--red);
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

.success-message {
    color: var(--green);
    font-size: 20px;
}

.edit-team-form {
    display: flex;
    align-items: flex-start;
    flex-direction: column;
}

.hidden {
    visibility: hidden;
}

#searchfield {
    width: 200px;
    padding: 5px;
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

.delete-team,
.edit-team {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
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

.delete-team:hover,
.edit-team:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

.margin-right {
    margin-right: 20px;
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

    .delete-team,
    .edit-team {
        padding: 10px 10px;
        font-size: 13px;
    }

    #teams-table {
        font-size: 15px;
    }

    .scrollable-container {
        width: 300px;
        overflow-x: scroll;
    }

    .position-delete-player-popup {
        left: 23%;
        top: 27%;
    }

    .position-edit-player-popup {
        left: 20%;
        top: 5%;
        padding: 5px;
    }

    .error-message,
    .success-message {
        font-size: 15px;
    }
}
</style>
