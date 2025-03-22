<template>
    <div>
        <h1>Leaderboard - Teams</h1>
        <div class="scrollable-container">
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
        </div>
    </div>
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
                        document.getElementById('team-leaderboard').style.border = 'none';
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
                    document.getElementById('team-leaderboard').style.border = 'none';
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

<style scoped>
#team-leaderboard {
    border-spacing: 10px 0;
    border: 2px solid var(--black);
    border-collapse: collapse;
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

h1 {
    margin-bottom: 15px;
    margin-top: 0;
}

.scrollable-container {
    width: fit-content;
    overflow-y: scroll;
    height: 350px;
    margin: 0 auto;
}

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    #team-leaderboard {
        font-size: 15px;
    }

    h1 {
        font-size: 20px;
    }

    .scrollable-container {
        width: 300px;
        overflow-x: scroll;
        height: fit-content;
    }
}
</style>
