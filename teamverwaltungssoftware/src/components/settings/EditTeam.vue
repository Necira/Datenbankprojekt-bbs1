<template>
    <h1>Edit existing team</h1>
    <div class="column">
        <input
            type="text"
            id="searchfield"
            placeholder="search for position,teamname..."
            @keyup="getFilteredTeam"
        />
        <span class="resultMessage"> {{ textResultMessage }}</span>
    </div>
    <table id="teams-table">
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
            textResultMessage: '',
            deleteableTeams: [],
            availablePlayer: [],
            editableTeams: [],
            tableTeams: [],
        };
    },
    methods: {
        displayTeamsTable() {
            fetch('http://localhost:3000/getTeams')
                .then(response => response.json())
                .then(data => {
                    this.tableTeams = [];

                    if (data.length === 0) {
                        document.getElementById('teams-table').innerHTML = 'No data available!';
                    }

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
                    document.getElementById('teams-table').innerHTML = 'No data available!';
                    return;
                });
        },
        openAndCloseDeleteTeamPopUpWindow() {
            this.openDeleteTeamPopUpWindow = !this.openDeleteTeamPopUpWindow;
            this.textSuccessMessage = '';

            if (this.openDeleteTeamPopUpWindow) {
                this.deleteableTeams = [];
                //  Display all available player in the select-option-fields
                fetch('http://localhost:3000/getActiveTeams')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            // Push data into array in order to display it with v-for
                            this.deleteableTeams.push({ id: data[i].teamID, name: data[i].teamname });
                        }
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
            this.textErrorMessage = '';

            if (this.openEditTeamForm) {
                this.availablePlayer = [];
                this.editableTeams = [];
                // Display all available player in the select-option-field
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
                            activePlayer.push({
                                id: activePlayerData[i].playerID,
                                name: activePlayerData[i].playername,
                            });
                        }

                        fetch('http://localhost:3000/getActiveTeammember')
                            .then(response => response.json())
                            .then(activeTeammemberData => {
                                let activeTeammember = [];
                                for (let i = 0; i < activeTeammemberData.length; i++) {
                                    activeTeammember.push({
                                        id: activeTeammemberData[i].playerID,
                                        name: activeTeammemberData[i].playername,
                                    });
                                }

                                // Display only player that are not deleted and are not in a team yet
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
                                            });
                                        }
                                    }
                                }

                                this.availablePlayer.push({ id: 'NULL', name: 'no player' });
                                if (availableTeammember.length > 0) {
                                    for (let i = 0; i < availableTeammember.length; i++) {
                                        // Push data into array in order to display it with v-for
                                        this.availablePlayer.push({
                                            id: availableTeammember[i].id,
                                            name: availableTeammember[i].name,
                                        });
                                    }
                                } else if (availableTeammember.length === 0 && activePlayer.length > 0) {
                                    for (let i = 0; i < activePlayer.length; i++) {
                                        // Push data into array in order to display it with v-for
                                        this.availablePlayer.push({
                                            id: activePlayer[i].id,
                                            name: activePlayer[i].name,
                                        });
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
        async editTeam() {
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
            let eloPointsTeam = 0;
            let choosenTeamMembers = [firstMember, secondMember, thirdMember, fourthMember, fifthMember];

            if (teamname.length === 0 || deleted.length === 0) {
                this.textErrorMessage = 'Please fill out at least one form field!';
                return;
            } else {
                this.textErrorMessage = '';
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
                this.textErrorMessage = 'Cannot add the same player twice!';
                return;
            } else {
                this.textErrorMessage = '';
            }

            // let teamdata = this.tableTeams.some(element => element.tableDataCellTeamname === teamname);

            if (teamname.length > 0) {
                for (let i = 0; i < this.tableTeams.length; i++) {
                    if (
                        this.tableTeams[i].tableDataCellTeamname === teamname &&
                        this.tableTeams[i].tableDataCellTeamID === Number(teamId)
                    ) {
                        this.textErrorMessage = '';
                        break;
                    } else if (
                        this.tableTeams[i].tableDataCellTeamname === teamname &&
                        this.tableTeams[i].tableDataCellTeamID !== Number(teamId)
                    ) {
                        this.textErrorMessage = 'Teamname already exists!';
                        return;
                    }
                }
            } else {
                this.textErrorMessage = '';
            }

            console.log(isNaN(firstMember), isNaN(secondMember));
            if (
                !isNaN(firstMember) &&
                !isNaN(secondMember) &&
                !isNaN(thirdMember) &&
                !isNaN(fourthMember) &&
                !isNaN(fifthMember)
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
                        console.log('if:', finalEloPoints);
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
                    changedTeamname: teamname,
                    changedDeletedValue: deleted,
                    changedFirstMember: firstMember,
                    changedSecondMember: secondMember,
                    changedThirdMember: thirdMember,
                    changedFourthMember: fourthMember,
                    changedFifthMember: fifthMember,
                    changedEloPoints: eloPointsTeam,
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
        getFilteredTeam() {
            let searchvalue = document.getElementById('searchfield').value;
            let teamtable = document.getElementById('teams-table');
            let tbodyTeamtable = teamtable.childNodes[1];
            let tbodyRows = tbodyTeamtable.childNodes;
            let counterDisplayedRows = 0;

            if (searchvalue.length === 0) {
                this.textResultMessage = '';

                for (let i = 1; i <= this.tableTeams.length; i++) {
                    tbodyRows[i].classList.remove('hidden');
                }
            } else {
                for (let i = 1; i <= this.tableTeams.length; i++) {
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

                this.textResultMessage =
                    'Found ' + counterDisplayedRows + ' datasets that matches ' + searchvalue;
            }
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
