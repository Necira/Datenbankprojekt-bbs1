<template>
    <h1>Edit existing team</h1>
    <table class="teams-table">
        <thead>
            <tr>
                <th>teamID</th>
                <th>teamname</th>
                <th>eloPoints</th>
                <th>playerID</th>
            </tr>
        </thead>
        <tbody id="tbody-teams-table"></tbody>
    </table>
    <RouterLink to="/TeamSettings"> Back </RouterLink>
</template>

<script>
export default {
    data() {
        return {
            name: 'EditTeam',
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

                        document.getElementById('tbody-teams-table').appendChild(newTableRow);
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
</style>
