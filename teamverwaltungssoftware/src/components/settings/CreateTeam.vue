<template>
    <h1>Create a new team</h1>
    <form class="createTeamForm" id="createTeamForm">
        <label for="teamname">teamname</label>
        <input id="teamname" name="teamname" />
        <label for="member">member</label>
        <div id="availabe-player">
            <div>
                <label for="Top-Lane">Top-Lane</label>
                <select id="Top-Lane" name="Top-Lane">
                    <option v-for="player in availablePlayerTopLane" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Jungle">Jungle</label>
                <select id="Jungle" name="Jungle">
                    <option v-for="player in availablePlayerJungle" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Mid-Lane">Mid-Lane</label>
                <select id="Mid-Lane" name="Mid-Lane">
                    <option v-for="player in availablePlayerMidLane" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Support">Support</label>
                <select id="Support" name="Support">
                    <option v-for="player in availablePlayerSupport" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Bot-Lane">Bot-Lane</label>
                <select id="Bot-Lane" name="Bot-Lane">
                    <option v-for="player in availablePlayerBotLane" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
        </div>
        <button type="button" @click="saveNewTeam">Save team</button>
    </form>
    <span class="success-message"> {{ textSuccessMessage }}</span>
    <span class="error-message">{{ textErrorMessage }}</span>
    <RouterLink to="/TeamSettings"> Back </RouterLink>
</template>

<script>
export default {
    data() {
        return {
            name: 'CreateTeam',
            textErrorMessage: '',
            textSuccessMessage: '',
            availablePlayerTopLane: [],
            availablePlayerMidLane: [],
            availablePlayerBotLane: [],
            availablePlayerSupport: [],
            availablePlayerJungle: [],
        };
    },
    methods: {
        async saveNewTeam() {
            let teamname = document.getElementById('teamname').value;
            let selectElementTopLane = document.getElementById('Top-Lane');
            let firstPlayerId = selectElementTopLane.options[selectElementTopLane.selectedIndex].id;
            let selectElementMidLane = document.getElementById('Mid-Lane');
            let secondPlayerId = selectElementMidLane.options[selectElementMidLane.selectedIndex].id;
            let selectElementJungle = document.getElementById('Jungle');
            let thirdPlayerId = selectElementJungle.options[selectElementJungle.selectedIndex].id;
            let selectElementSupport = document.getElementById('Support');
            let fourthPlayerId = selectElementSupport.options[selectElementSupport.selectedIndex].id;
            let selectElementBotLane = document.getElementById('Bot-Lane');
            let fifthPlayerId = selectElementBotLane.options[selectElementBotLane.selectedIndex].id;
            let choosenTeamMembers = [
                firstPlayerId,
                secondPlayerId,
                thirdPlayerId,
                fourthPlayerId,
                fifthPlayerId,
            ];

            // Calculate Elo-Points, if team is complete
            let eloPointsTeam = await fetch('http://localhost:3000/getPlayer')
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
                    let finalEloPoints = calculatedEloPoints / 5;
                    return finalEloPoints;
                })
                .catch(error => {
                    console.error(error);
                    return;
                });

            if (teamname.length === 0) {
                this.textErrorMessage = 'Please fill out the entire form!';
                this.textSuccessMessage = '';
                return;
            } else if (teamname.length > 0) {
                let teamnameExists = await fetch('http://localhost:3000/getTeams')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            if (teamname === data[i].teamname) {
                                return true;
                            }
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });

                if (teamnameExists) {
                    this.textErrorMessage = 'Teamname already exists!';
                    return;
                } else {
                    this.textErrorMessage = '';
                }
            }

            fetch('http://localhost:3000/createNewTeam', {
                method: 'POST',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    newTeamname: teamname,
                    newEloPoints: eloPointsTeam,
                    firstMember: firstPlayerId,
                    secondMember: secondPlayerId,
                    thirdMember: thirdPlayerId,
                    fourthMember: fourthPlayerId,
                    fifthMember: fifthPlayerId,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        let createTeamForm = document.getElementById('createTeamForm').childNodes;
                        let playeroptions = document.getElementsByClassName('playeroptions');

                        // Set Values of user input to defautl
                        createTeamForm[1].value = '';
                        for (let i = 0; i < playeroptions.length; i++) {
                            playeroptions[i].checked = false;
                        }

                        this.textSuccessMessage = 'Added new team successfully!';
                        return response.json();
                    }
                })
                .catch(error => {
                    console.error(error);
                    return;
                });
        },
        displayAvailablePlayer() {
            // Display all available player-IDs in the select-option-field
            fetch('http://localhost:3000/getActivePlayer')
                .then(response => response.json())
                .then(activePlayerData => {
                    let activePlayerIDs = [];
                    let activePlayernames = [];
                    let activePlayerPosition = [];

                    for (let i = 0; i < activePlayerData.length; i++) {
                        activePlayerIDs.push(activePlayerData[i].playerID);
                        activePlayernames.push(activePlayerData[i].playername);
                        activePlayerPosition.push(activePlayerData[i].position);
                    }

                    fetch('http://localhost:3000/getActiveTeammember')
                        .then(response => response.json())
                        .then(activeTeammemberData => {
                            let activeTeammemberIDs = [];

                            for (let i = 0; i < activeTeammemberData.length; i++) {
                                activeTeammemberIDs.push(activeTeammemberData[i].playerID);
                            }

                            // Display only player that are not deleted and are not in a team yet
                            let availableTeammemberIDs = [];
                            let availableTeammemberNames = [];
                            let availableTeammemberPositions = [];

                            for (let i = 0; i < activeTeammemberIDs.length; i++) {
                                for (let a = 0; a < activePlayerIDs.length; a++) {
                                    if (
                                        activeTeammemberIDs[i] !== activePlayerIDs[a] &&
                                        !availableTeammemberIDs.includes(activePlayerIDs[a]) &&
                                        !activeTeammemberIDs.includes(activePlayerIDs[a])
                                    ) {
                                        availableTeammemberIDs.push(activePlayerIDs[a]);
                                        availableTeammemberNames.push(activePlayernames[a]);
                                        availableTeammemberPositions.push(activePlayerPosition[a]);
                                    }
                                }
                            }

                            if (availableTeammemberIDs.length > 0) {
                                for (let i = 0; i < availableTeammemberPositions.length; i++) {
                                    // Push data into array in order to display it with v-for
                                    if (availableTeammemberPositions[i] === 'Top-Lane') {
                                        this.availablePlayerTopLane.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Jungle') {
                                        this.availablePlayerJungle.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Mid-lane') {
                                        this.availablePlayerMidLane.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Bot-Lane') {
                                        this.availablePlayerBotLane.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Support') {
                                        this.availablePlayerSupport.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }
                                }
                            } else if (
                                availableTeammemberIDs.length === 0 &&
                                activePlayerIDs.length > 0 &&
                                activePlayernames.length > 0
                            ) {
                                for (let i = 0; i < activePlayerIDs.length; i++) {
                                    // Push data into array in order to display it with v-for
                                    if (availableTeammemberPositions[i] === 'Top-Lane') {
                                        this.availablePlayerTopLane.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Jungle') {
                                        this.availablePlayerJungle.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Mid-lane') {
                                        this.availablePlayerMidLane.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Bot-Lane') {
                                        this.availablePlayerBotLane.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }

                                    if (availableTeammemberPositions[i] === 'Support') {
                                        this.availablePlayerSupport.push({
                                            id: availableTeammemberIDs[i],
                                            name: availableTeammemberNames[i],
                                        });
                                    }
                                }
                            } else {
                                document.getElementById('availabe-player').innerHTML = 'No player available!';
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
        },
    },
    mounted() {
        // call function, when component is created
        this.displayAvailablePlayer();
    },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.create-team-form {
    display: flex;
    justify-content: center;
    flex-direction: column;
}

.error-message {
    color: red;
    font-size: 20px;
}

.success-message {
    color: green;
    font-size: 20px;
}

#availabe-player {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
}
</style>
