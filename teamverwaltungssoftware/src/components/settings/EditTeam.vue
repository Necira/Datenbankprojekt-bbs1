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
        <tbody id="tbody-teams-table"></tbody>
    </table>
    <button type="button" @click="openAndCloseDeleteTeamPopUpWindow">Delete team</button>
    <button type="button" @click="openAndCloseEditTeamForm">Edit team</button>
    <RouterLink to="/TeamSettings"> Back </RouterLink>

    <div class="popUp-Window" v-if="openDeleteTeamPopUpWindow">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseDeleteTeamPopUpWindow">X</button>
        <div class="column">
            <label for="selectTeamname">Choose a team:</label>
            <select id="selectTeamname" name="selectTeamname"></select>
            <button type="button" @click="deleteTeam">Delete team</button>
        </div>
        <span class="success-message"> {{ textSuccessMessage }}</span>
    </div>

    <div v-if="openEditTeamForm" class="popUp-Window">
        <button type="button" class="close-PopUpWindow" @click="openAndCloseEditTeamForm">X</button>
        <form class="edit-team-form">
            <label for="selectTeamID">TeamID:</label>
            <select id="selectTeamID" name="selectTeamID"></select>
            <label for="teamname">teamname:</label>
            <input id="teamname" name="teamname" />
            <label for="deleted">deleted:</label>
            <input type="number" min="0" max="1" id="deleted" name="deleted" />
            <label for="firstMember">firstMember:</label>
            <select id="firstMember" name="firstMember"></select>
            <label for="secondMember">secondMember:</label>
            <select id="secondMember" name="secondMember"></select>
            <label for="thirdMember">thirdMember:</label>
            <select id="thirdMember" name="thirdMember"></select>
            <label for="fourthMember">fourthMember:</label>
            <select id="fourthMember" name="fourthMember"></select>
            <label for="fifthMember">fifthMember:</label>
            <select id="fifthMember" name="fifthMember"></select>

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
        };
    },
    methods: {
        displayTeamsTable() {
            document.getElementById('tbody-teams-table').innerHTML = '';

            // Start server.js and databank for a functional get-request
            fetch('http://localhost:3000/getTeams')
                .then(response => response.json())
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        let newTableRow = document.createElement('tr');

                        let tableDataCellTeamID = document.createElement('td');
                        tableDataCellTeamID.innerHTML = data[i].teamID;
                        newTableRow.appendChild(tableDataCellTeamID);

                        let tableDataCellTeamname = document.createElement('td');
                        tableDataCellTeamname.innerHTML = data[i].teamname;
                        newTableRow.appendChild(tableDataCellTeamname);

                        let tableDataCellEloPoints = document.createElement('td');
                        tableDataCellEloPoints.innerHTML = data[i].eloPoints;
                        newTableRow.appendChild(tableDataCellEloPoints);

                        let tableDataCellDeleted = document.createElement('td');
                        tableDataCellDeleted.innerHTML = data[i].deleted;
                        newTableRow.appendChild(tableDataCellDeleted);

                        let tableDataCellFirstMember = document.createElement('td');
                        if (data[i].firstMember !== null) {
                            tableDataCellFirstMember.innerHTML = data[i].firstMember;
                        } else {
                            tableDataCellFirstMember.innerHTML = 'null';
                        }
                        newTableRow.appendChild(tableDataCellFirstMember);

                        let tableDataCellSecondMember = document.createElement('td');
                        if (data[i].secondMember !== null) {
                            tableDataCellSecondMember.innerHTML = data[i].secondMember;
                        } else {
                            tableDataCellSecondMember.innerHTML = 'null';
                        }
                        newTableRow.appendChild(tableDataCellSecondMember);

                        let tableDataCellThirdMember = document.createElement('td');
                        if (data[i].thirdMember !== null) {
                            tableDataCellThirdMember.innerHTML = data[i].thirdMember;
                        } else {
                            tableDataCellThirdMember.innerHTML = 'null';
                        }
                        newTableRow.appendChild(tableDataCellThirdMember);

                        let tableDataCellFourthMember = document.createElement('td');
                        if (data[i].fourthMember !== null) {
                            tableDataCellFourthMember.innerHTML = data[i].fourthMember;
                        } else {
                            tableDataCellFourthMember.innerHTML = 'null';
                        }
                        newTableRow.appendChild(tableDataCellFourthMember);

                        let tableDataCellFifthMember = document.createElement('td');
                        if (data[i].fifthMember !== null) {
                            tableDataCellFifthMember.innerHTML = data[i].fifthMember;
                        } else {
                            tableDataCellFifthMember.innerHTML = 'null';
                        }
                        newTableRow.appendChild(tableDataCellFifthMember);

                        document.getElementById('tbody-teams-table').appendChild(newTableRow);
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
                            let newTeamOption = document.createElement('option');
                            newTeamOption.innerHTML = data[i].teamname;
                            newTeamOption.id = data[i].teamID;
                            document.getElementById('selectTeamname').appendChild(newTeamOption);
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

            if (this.openEditTeamForm) {
                /** Start server.js and databank for a functional post-request
                 *  Display all available player in the select-option-field
                 */
                fetch('http://localhost:3000/getTeams')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            let teamOption = document.createElement('option');
                            teamOption.innerHTML = data[i].teamID;
                            teamOption.id = data[i].teamID;

                            document.getElementById('selectTeamID').appendChild(teamOption);
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });

                fetch('http://localhost:3000/getActivePlayer')
                    .then(response => response.json())
                    .then(data => {
                        let selectFieldFirstMember = document.getElementById('firstMember');
                        let selectFieldSecondMember = document.getElementById('secondMember');
                        let selectFieldthirdMember = document.getElementById('thirdMember');
                        let selectFieldFourthMember = document.getElementById('fourthMember');
                        let selectFieldFifthMember = document.getElementById('fifthMember');

                        let noPlayerOptionFirstMember = document.createElement('option');
                        noPlayerOptionFirstMember.innerHTML = 'no player';
                        noPlayerOptionFirstMember.id = null;

                        let noPlayerOptionSecondMember = document.createElement('option');
                        noPlayerOptionSecondMember.innerHTML = 'no player';
                        noPlayerOptionSecondMember.id = null;

                        let noPlayerOptionThirdMember = document.createElement('option');
                        noPlayerOptionThirdMember.innerHTML = 'no player';
                        noPlayerOptionThirdMember.id = null;

                        let noPlayerOptionFourthMember = document.createElement('option');
                        noPlayerOptionFourthMember.innerHTML = 'no player';
                        noPlayerOptionFourthMember.id = null;

                        let noPlayerOptionFifthMember = document.createElement('option');
                        noPlayerOptionFifthMember.innerHTML = 'no player';
                        noPlayerOptionFifthMember.id = null;

                        selectFieldFirstMember.appendChild(noPlayerOptionFirstMember);
                        selectFieldSecondMember.appendChild(noPlayerOptionSecondMember);
                        selectFieldthirdMember.appendChild(noPlayerOptionThirdMember);
                        selectFieldFourthMember.appendChild(noPlayerOptionFourthMember);
                        selectFieldFifthMember.appendChild(noPlayerOptionFifthMember);

                        for (let i = 0; i < data.length; i++) {
                            let newPlayerOptionFirstMember = document.createElement('option');
                            newPlayerOptionFirstMember.innerHTML = data[i].playerID;
                            newPlayerOptionFirstMember.id = data[i].playerID;

                            let newPlayerOptionSecondMember = document.createElement('option');
                            newPlayerOptionSecondMember.innerHTML = data[i].playerID;
                            newPlayerOptionSecondMember.id = data[i].playerID;

                            let newPlayerOptionThirdMember = document.createElement('option');
                            newPlayerOptionThirdMember.innerHTML = data[i].playerID;
                            newPlayerOptionThirdMember.id = data[i].playerID;

                            let newPlayerOptionFourthMember = document.createElement('option');
                            newPlayerOptionFourthMember.innerHTML = data[i].playerID;
                            newPlayerOptionFourthMember.id = data[i].playerID;

                            let newPlayerOptionFifthMember = document.createElement('option');
                            newPlayerOptionFifthMember.innerHTML = data[i].playerID;
                            newPlayerOptionFifthMember.id = data[i].playerID;

                            selectFieldFirstMember.appendChild(newPlayerOptionFirstMember);
                            selectFieldSecondMember.appendChild(newPlayerOptionSecondMember);
                            selectFieldthirdMember.appendChild(newPlayerOptionThirdMember);
                            selectFieldFourthMember.appendChild(newPlayerOptionFourthMember);
                            selectFieldFifthMember.appendChild(newPlayerOptionFifthMember);
                        }
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
            console.log('hello there');
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
