<template>
    <navigationBar></navigationBar>
    <h1>Edit existing team</h1>
    <div class="column">
        <input
            type="text"
            id="searchfield"
            placeholder="search for position,teamname..."
            @keyup="getFilteredTeam"
        />
        <span class="resultMessage"> {{ resultMessage }}</span>
    </div>
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
    <button type="button" @click="openAndCloseDeleteTeamPopUpWindow">Delete team</button>
    <button type="button" @click="openAndCloseEditTeamForm">Edit team</button>
    <RouterLink to="/TeamSettings"> Back </RouterLink>

    <div class="popUp-Window" v-if="openDeleteTeamPopUpWindow">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseDeleteTeamPopUpWindow">X</button>
        <div class="column">
            <label for="selectTeamname">Choose a team:</label>
            <select id="selectTeamname" name="selectTeamname">
                <option v-for="team in deleteableTeams" :key="team" :id="team.id">{{ team.name }}</option>
            </select>
            <button type="button" @click="deleteTeam">Delete team</button>
        </div>
        <span class="success-message"> {{ successMessage }}</span>
    </div>

    <div v-if="openEditTeamForm" class="popUp-Window">
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

            <button type="button" @click="validateEditTeamForm">Edit team</button>
        </form>
        <span class="success-message"> {{ successMessage }}</span>
        <span class="error-message">{{ errorMessage }}</span>
    </div>
</template>

<script>
import navigationBar from '../Atoms/navigationBar.vue';

export default {
    components:{
        navigationBar,
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
            fetch('http://localhost:3000/getTeams')
                .then(response => response.json())
                .then(data => {
                    this.fetchedTeamdata = [];

                    if (data.length === 0) {
                        document.getElementById('teams-table').innerHTML = 'No data available!';
                    }

                    for (let i = 0; i < data.length; i++) {
                        // Display fetched data in the select-option-fields above
                        if (data[i].firstMember === null) {
                            data[i].firstMember = 'NULL';
                        }

                        if (data[i].secondMember === null) {
                            data[i].secondMember = 'NULL';
                        }

                        if (data[i].thirdMember === null) {
                            data[i].thirdMember = 'NULL';
                        }

                        if (data[i].fourthMember === null) {
                            data[i].fourthMember = 'NULL';
                        }

                        if (data[i].fifthMember === null) {
                            data[i].fifthMember = 'NULL';
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
                                if (availableTeammember.length > 0) {
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
                                } else if (availableTeammember.length === 0 && activePlayer.length > 0) {
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
                        this.successMessage = 'deleted player successfully!';
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
                        this.successMessage = 'updated player successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
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
}

.success-message {
    color: green;
    font-size: 20px;
}

.error-message {
    color: red;
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

.success-message {
    color: green;
    font-size: 20px;
}

.edit-team-form {
    display: flex;
    justify-content: center;
    flex-direction: column;
}

.hidden {
    visibility: hidden;
}

#searchfield {
    width: 200px;
}
</style>
