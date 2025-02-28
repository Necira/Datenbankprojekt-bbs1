<template>
    <div>
        <h1>Leaderboard - Player</h1>
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
    </div>
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

<style scoped>
#player-leaderboard {
    border-spacing: 10px 0;
}

th,
td {
    text-align: left;
}

h1 {
    margin-bottom: 15px;
    margin-top: 0;
}

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    #player-leaderboard {
        font-size: 15px;
    }

    h1 {
        font-size: 20px;
    }
}
</style>
