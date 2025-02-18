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
                    <option id="NULL">No player</option>
                    <option v-for="player in availablePlayerTopLane" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Jungle">Jungle</label>
                <select id="Jungle" name="Jungle">
                    <option id="NULL">No player</option>
                    <option v-for="player in availablePlayerJungle" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Mid-Lane">Mid-Lane</label>
                <select id="Mid-Lane" name="Mid-Lane">
                    <option id="NULL">No player</option>
                    <option v-for="player in availablePlayerMidLane" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Support">Support</label>
                <select id="Support" name="Support">
                    <option id="NULL">No player</option>
                    <option v-for="player in availablePlayerSupport" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
            <div>
                <label for="Bot-Lane">Bot-Lane</label>
                <select id="Bot-Lane" name="Bot-Lane">
                    <option id="NULL">No player</option>
                    <option v-for="player in availablePlayerBotLane" :key="player" :id="player.id">
                        {{ player.name }}
                    </option>
                </select>
            </div>
        </div>
        <button type="button" @click="validateForm">Save team</button>
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
        async validateForm() {
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
                Number(firstPlayerId),
                Number(secondPlayerId),
                Number(thirdPlayerId),
                Number(fourthPlayerId),
                Number(fifthPlayerId),
            ];
            let eloPointsTeam = 0;

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

            if (
                firstPlayerId !== 'NULL' &&
                secondPlayerId !== 'NULL' &&
                thirdPlayerId !== 'NULL' &&
                fourthPlayerId !== 'NULL' &&
                fifthPlayerId !== 'NULL'
            ) {
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
                        return finalEloPoints;
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            } else {
                if (firstPlayerId === 'NULL') {
                    firstPlayerId = null;
                }

                if (secondPlayerId === 'NULL') {
                    secondPlayerId = null;
                }

                if (thirdPlayerId === 'NULL') {
                    thirdPlayerId = null;
                }

                if (fourthPlayerId === 'NULL') {
                    fourthPlayerId = null;
                }

                if (fifthPlayerId === 'NULL') {
                    fifthPlayerId = null;
                }

                eloPointsTeam++;
            }

            this.postNewTeam(
                teamname,
                firstPlayerId,
                secondPlayerId,
                thirdPlayerId,
                fourthPlayerId,
                fifthPlayerId,
                eloPointsTeam,
            );
        },
        async postNewTeam(
            setTeamname,
            setFirstPlayer,
            setSecondPlayer,
            setThirdPlayer,
            setFourthPlayer,
            setFifthPlayer,
            setEloPoints,
        ) {
            fetch('http://localhost:3000/createNewTeam', {
                method: 'POST',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    newTeamname: setTeamname,
                    newEloPoints: setEloPoints,
                    firstMember: setFirstPlayer,
                    secondMember: setSecondPlayer,
                    thirdMember: setThirdPlayer,
                    fourthMember: setFourthPlayer,
                    fifthMember: setFifthPlayer,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        let createTeamForm = document.getElementById('createTeamForm').childNodes;
                        let playeroptions = document.getElementsByClassName('playeroptions');

                        // Set Values of user input to default after new team is added successfully
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
            fetch('http://localhost:3000/getActivePlayer')
                .then(response => response.json())
                .then(activePlayerData => {
                    let activePlayer = [];

                    for (let i = 0; i < activePlayerData.length; i++) {
                        // Display all available player-IDs in the select-option-field
                        activePlayer.push({
                            id: activePlayerData[i].playerID,
                            name: activePlayerData[i].playername,
                            position: activePlayerData[i].position,
                        });
                    }
                    console.log('activePlayer', activePlayer);

                    fetch('http://localhost:3000/getActiveTeammember')
                        .then(response => response.json())
                        .then(activeTeammemberData => {
                            let activeTeammemberIDs = [];

                            for (let i = 0; i < activeTeammemberData.length; i++) {
                                // console.log(activeTeammemberData[i]);
                                if (!activeTeammemberIDs.includes(activeTeammemberData[i].playerID)) {
                                    activeTeammemberIDs.push(activeTeammemberData[i].playerID);
                                }
                            }
                            console.log('activeTeammemberIDs', activeTeammemberIDs);

                            let availableTeammember = [];

                            for (let i = 0; i < activeTeammemberIDs.length; i++) {
                                for (let a = 0; a < activePlayer.length; a++) {
                                    if (
                                        activeTeammemberIDs[i] !== activePlayer[a].id &&
                                        !availableTeammember.some(
                                            element => element.id === activePlayer[a].id,
                                        ) &&
                                        !activeTeammemberIDs.includes(activePlayer[a].id)
                                    ) {
                                        console.log('activePlayer[a]', {
                                            id: activePlayer[a].id,
                                            name: activePlayer[a].name,
                                            position: activePlayer[a].position,
                                        });
                                        console.log('activeTeammemberIDs[i]', activeTeammemberIDs[i]);
                                        availableTeammember.push({
                                            id: activePlayer[a].id,
                                            name: activePlayer[a].name,
                                            position: activePlayer[a].position,
                                        });
                                    }
                                }
                            }

                            // Display not deleted player, that are not in a team yet
                            if (availableTeammember.length > 0) {
                                console.log('if');
                                console.log(availableTeammember);
                                for (let i = 0; i < availableTeammember.length; i++) {
                                    if (availableTeammember[i].position === 'Top-Lane') {
                                        this.availablePlayerTopLane.push({
                                            id: availableTeammember[i].id,
                                            name: availableTeammember[i].name,
                                        });
                                    }

                                    if (availableTeammember[i].position === 'Jungle') {
                                        this.availablePlayerJungle.push({
                                            id: availableTeammember[i].id,
                                            name: availableTeammember[i].name,
                                        });
                                    }

                                    if (availableTeammember[i].position === 'Mid-lane') {
                                        this.availablePlayerMidLane.push({
                                            id: availableTeammember[i].id,
                                            name: availableTeammember[i].name,
                                        });
                                    }

                                    if (availableTeammember[i].position === 'Bot-Lane') {
                                        this.availablePlayerBotLane.push({
                                            id: availableTeammember[i].id,
                                            name: availableTeammember[i].name,
                                        });
                                    }

                                    if (availableTeammember[i].position === 'Support') {
                                        this.availablePlayerSupport.push({
                                            id: availableTeammember[i].id,
                                            name: availableTeammember[i].name,
                                        });
                                    }
                                }
                            } else if (availableTeammember.length === 0 && activePlayer.length > 0) {
                                console.log('else if');
                                for (let i = 0; i < activePlayer.length; i++) {
                                    if (activePlayerData[i].position === 'Top-Lane') {
                                        this.availablePlayerTopLane.push({
                                            id: activePlayer[i].id,
                                            name: activePlayer[i].name,
                                        });
                                    }

                                    if (activePlayerData[i].position === 'Jungle') {
                                        this.availablePlayerJungle.push({
                                            id: activePlayer[i].id,
                                            name: activePlayer[i].name,
                                        });
                                    }

                                    if (activePlayerData[i].position === 'Mid-lane') {
                                        this.availablePlayerMidLane.push({
                                            id: activePlayer[i].id,
                                            name: activePlayer[i].name,
                                        });
                                    }

                                    if (activePlayerData[i].position === 'Bot-Lane') {
                                        this.availablePlayerBotLane.push({
                                            id: activePlayer[i].id,
                                            name: activePlayer[i].name,
                                        });
                                    }

                                    if (activePlayerData[i].position === 'Support') {
                                        this.availablePlayerSupport.push({
                                            id: activePlayer[i].id,
                                            name: activePlayer[i].name,
                                        });
                                    }
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
