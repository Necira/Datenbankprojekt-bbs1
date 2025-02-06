<template>
    <table id="team-leaderboard">
        <thead>
            <tr>
                <th>teamID</th>
                <th>teamname</th>
                <th>eloPoints</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="row in leaderboarddata" :key="row">
                <td>{{ row.tableDataCellTeamId }}</td>
                <td>{{ row.tableDataCellTeamname }}</td>
                <td>{{ row.tableDataCellEloPoints }}</td>
            </tr>
        </tbody>
    </table>
</template>

<script>
export default {
    name: 'teamLeaderboard',
    data() {
        return {
            leaderboarddata: [],
        };
    },
    methods: {
        displayTeamLeaderboard() {
            fetch('http://localhost:3000/getTeamLeaderboard')
                .then(response => response.json())
                .then(data => {
                    if (data.length === 0) {
                        document.getElementById('team-leaderboard').innerHTML = 'No data available!';
                    }

                    for (let i = 0; i < data.length; i++) {
                        // Push data into array in order to display it with v-for
                        this.leaderboarddata.push({
                            tableDataCellTeamId: data[i].teamID,
                            tableDataCellTeamname: data[i].teamname,
                            tableDataCellEloPoints: data[i].eloPoints,
                        });
                    }
                })
                .catch(error => {
                    console.error(error);
                    document.getElementById('team-leaderboard').innerHTML = 'No data available!';
                    return;
                });
        },
    },
    mounted() {
        // call function, when component is created
        this.displayTeamLeaderboard();
    },
};
</script>

<style scoped></style>
