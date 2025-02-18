<template>
    <table id="player-leaderboard">
        <thead>
            <tr>
                <th>playerID</th>
                <th>playername</th>
                <th>eloPoints</th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="row in leaderboarddata" :key="row">
                <td>{{ row.tableDataCellPlayerId }}</td>
                <td>{{ row.tableDataCellPlayername }}</td>
                <td>{{ row.tableDataCellEloPoints }}</td>
            </tr>
        </tbody>
    </table>
</template>

<script>
export default {
    name: 'playerLeaderboard',
    data() {
        return {
            leaderboarddata: [],
        };
    },
    methods: {
        displayPlayerLeaderboard() {
            fetch('http://localhost:3000/getPlayerLeaderboard')
                .then(response => response.json())
                .then(data => {
                    if (data.length === 0) {
                        document.getElementById('player-leaderboard').innerHTML = 'No data available!';
                    }

                    for (let i = 0; i < data.length; i++) {
                        // Push data into array in order to display it with v-for
                        this.leaderboarddata.push({
                            tableDataCellPlayerId: data[i].playerID,
                            tableDataCellPlayername: data[i].playername,
                            tableDataCellEloPoints: data[i].eloPoints,
                        });
                    }
                })
                .catch(error => {
                    console.error(error);
                    document.getElementById('player-leaderboard').innerHTML = 'No data available!';
                    return;
                });
        },
    },
    mounted() {
        // call function, when component is created
        this.displayPlayerLeaderboard();
    },
};
</script>

<style scoped></style>
