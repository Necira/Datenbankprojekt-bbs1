<template>
    <h1>Edit existing team</h1>
    <table class="teams-table">
        <thead>
            <tr>
                <th>teamID</th>
                <th>teamname</th>
                <th>eloPoints</th>
                <th>playerID</th>
                <th>deleted</th>
            </tr>
        </thead>
        <tbody id="tbody-teams-table"></tbody>
    </table>
    <button type="button" @click="openAndCloseDeleteTeamPopUpWindow">Delete team</button>
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
</template>

<script>
export default {
    data() {
        return {
            name: 'EditTeam',
            openDeleteTeamPopUpWindow: false,
            textSuccessMessage: '',
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

                        let tableDataCellPlayerID = document.createElement('td');
                        tableDataCellPlayerID.innerHTML = data[i].playerID;
                        newTableRow.appendChild(tableDataCellPlayerID);

                        let tableDataCellDeleted = document.createElement('td');
                        tableDataCellDeleted.innerHTML = data[i].deleted;
                        newTableRow.appendChild(tableDataCellDeleted);

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

            if (this.openDeleteTeamPopUpWindow) {
                /** Start server.js and databank for a functional post-request
                 *  Display all available player in the select-option-field
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
        deleteTeam() {
            let selectElement = document.getElementById('selectTeamname');
            let idSelectedOption = selectElement.options[selectElement.selectedIndex].id;

            console.log(idSelectedOption);

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
</style>
