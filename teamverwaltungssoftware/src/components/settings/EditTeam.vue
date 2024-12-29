<template>
    <h1>Edit existing team</h1>
    <table class="teams-table">
        <thead>
            <tr>
                <th>teamID</th>
                <th>teamname</th>
                <th>eloPoints</th>
                <th>deleted</th>
                <th>firstMember</th>
                <th>secondMember</th>
                <th>thirdMember</th>
                <th>fourthMember</th>
                <th>fifthMember</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="row in tableTeams" :key="row">
                <td>{{ row.tableDataCellTeamID }}</td>
                <td>{{ row.tableDataCellTeamname }}</td>
                <td>{{ row.tableDataCellEloPoints }}</td>
                <td>{{ row.tableDataCellDeleted }}</td>
                <td>{{ row.tableDataCellFirstMember }}</td>
                <td>{{ row.tableDataCellSecondMember }}</td>
                <td>{{ row.tableDataCellThirdMember }}</td>
                <td>{{ row.tableDataCellFourthMember }}</td>
                <td>{{ row.tableDataCellFifthMember }}</td>
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
        <span class="success-message"> {{ textSuccessMessage }}</span>
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
            <label for="firstMember">firstMember:</label>
            <select id="firstMember" name="firstMember">
                <option v-for="player in availablePlayer" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="secondMember">secondMember:</label>
            <select id="secondMember" name="secondMember">
                <option v-for="player in availablePlayer" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="thirdMember">thirdMember:</label>
            <select id="thirdMember" name="thirdMember">
                <option v-for="player in availablePlayer" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="fourthMember">fourthMember:</label>
            <select id="fourthMember" name="fourthMember">
                <option v-for="player in availablePlayer" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>
            <label for="fifthMember">fifthMember:</label>
            <select id="fifthMember" name="fifthMember">
                <option v-for="player in availablePlayer" :key="player" :id="player.id">
                    {{ player.name }}
                </option>
            </select>

            <button type="button" @click="editTeam">Edit team</button>
        </form>
        <span class="success-message"> {{ textSuccessMessage }}</span>
        <span class="error-message">{{ textErrorMessage }}</span>
    </div>
</template>

<script>
export default {
    data() {
        return {
            name: 'EditTeam',
            openDeleteTeamPopUpWindow: false,
            openEditTeamForm: false,
            textSuccessMessage: '',
            textErrorMessage: '',
            deleteableTeams: [],
            availablePlayer: [],
            editableTeams: [],
            tableTeams: [],
        };
    },
    methods: {
        displayTeamsTable() {
            // Start server.js and databank for a functional get-request
            fetch('http://localhost:3000/getTeams')
                .then(response => response.json())
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        // Push data into array in order to display it with v-for
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

                        this.tableTeams.push({
                            tableDataCellTeamID: data[i].teamID,
                            tableDataCellTeamname: data[i].teamname,
                            tableDataCellEloPoints: data[i].eloPoints,
                            tableDataCellDeleted: data[i].deleted,
                            tableDataCellFirstMember: data[i].firstMember,
                            tableDataCellSecondMember: data[i].secondMember,
                            tableDataCellThirdMember: data[i].thirdMember,
                            tableDataCellFourthMember: data[i].fourthMember,
                            tableDataCellFifthMember: data[i].fifthMember,
                        });
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        openAndCloseDeleteTeamPopUpWindow() {
            this.openDeleteTeamPopUpWindow = !this.openDeleteTeamPopUpWindow;
            this.textSuccessMessage = '';

            if (this.openDeleteTeamPopUpWindow) {
                /** Start server.js and databank for a functional post-request
                 *  Display all available player in the select-option-fields
                 */
                fetch('http://localhost:3000/getActiveTeams')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            // Push data into array in order to display it with v-for
                            this.deleteableTeams.push({ id: data[i].teamID, name: data[i].teamname });
                        }
                        console.log(this.deleteableTeams);
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
        openAndCloseEditTeamForm() {
            this.openEditTeamForm = !this.openEditTeamForm;
            this.textSuccessMessage = '';
            this.availablePlayer = [];

            if (this.openEditTeamForm) {
                /** Start server.js and databank for a functional post-request
                 *  Display all available player in the select-option-field
                 */
                fetch('http://localhost:3000/getTeams')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            // Push data into array in order to display it with v-for
                            this.editableTeams.push(data[i].teamID);
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });

                fetch('http://localhost:3000/getActivePlayer')
                    .then(response => response.json())
                    .then(activePlayerData => {
                        let activePlayer = [];
                        for (let i = 0; i < activePlayerData.length; i++) {
                            activePlayer.push(activePlayerData[i].playerID);
                        }

                        fetch('http://localhost:3000/getActiveTeammember')
                            .then(response => response.json())
                            .then(activeTeammemberData => {
                                let activeTeammember = [];
                                for (let i = 0; i < activeTeammemberData.length; i++) {
                                    activeTeammember.push(activeTeammemberData[i].playerID);
                                }

                                // Display only player that are not deleted and are not in a team yet
                                let availableTeammember = [];
                                for (let i = 0; i < activeTeammember.length; i++) {
                                    for (let a = 0; a < activePlayer.length; a++) {
                                        if (
                                            activeTeammember[i] !== activePlayer[a] &&
                                            !availableTeammember.includes(activePlayer[a]) &&
                                            !activeTeammember.includes(activePlayer[a])
                                        ) {
                                            availableTeammember.push(activePlayer[a]);
                                        }
                                    }
                                }

                                this.availablePlayer.push({ id: 'NULL', name: 'no player' });
                                for (let i = 0; i < availableTeammember.length; i++) {
                                    // Push data into array in order to display it with v-for
                                    this.availablePlayer.push({
                                        id: availableTeammember[i],
                                        name: availableTeammember[i],
                                    });
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

            // Start server.js and databank for a functional patch-request
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
                        // Update table in frontend after new changes
                        this.displayTeamsTable();
                        this.textSuccessMessage = 'deleted player successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        editTeam() {
            this.textSuccessMessage = '';

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
                this.textErrorMessage = 'Please fill out at least one form field!';
                return;
            } else {
                this.textErrorMessage = '';
            }

            console.log(firstMember, secondMember, thirdMember, fourthMember);

            // TO-DO: fix later
            // if (
            //     firstMember === secondMember ||
            //     firstMember === thirdMember ||
            //     firstMember === fourthMember ||
            //     firstMember === fifthMember ||
            //     secondMember === thirdMember ||
            //     secondMember === fourthMember ||
            //     secondMember === fifthMember ||
            //     thirdMember === fourthMember ||
            //     thirdMember === fifthMember ||
            //     fourthMember === fifthMember
            // ) {
            //     this.textErrorMessage = 'Cannot add the same player twice!';
            //     return;
            // } else {
            //     this.textErrorMessage = '';
            // }

            // Start server.js and databank for a functional put-request
            fetch('http://localhost:3000/updateTeam', {
                method: 'PUT',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    changedTeamname: teamname,
                    changedDeletedValue: deleted,
                    changedFirstMember: firstMember,
                    changedSecondMember: secondMember,
                    changedThirdMember: thirdMember,
                    changedFourthMember: fourthMember,
                    changedFifthMember: fifthMember,
                    teamId: teamId,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        // display new changes in player table
                        this.displayTeamsTable();
                        this.textSuccessMessage = 'updated player successfully!';
                        return response.json();
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
        this.displayTeamsTable();
    },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.teams-table {
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
</style>
