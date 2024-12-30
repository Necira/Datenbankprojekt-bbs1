<template>
    <h1>Create a new team</h1>
    <form class="create-team-form">
        <label for="teamname">teamname</label>
        <input id="teamname" name="teamname" />
        <label for="member">member</label>
        <div id="availabe-player">
            <div v-for="player in availablePlayer" :key="player">
                <input type="checkbox" :id="player.id" />
                <label :for="player.id">{{ player.name }}</label>
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
            availablePlayer: [],
        };
    },
    methods: {
        async saveNewTeam() {
            let teamname = document.getElementById('teamname').value;
            let availablePlayerContainer = document.getElementById('availabe-player').childNodes;
            let eloPointsTeam = 0;
            let choosenTeamMembers = [];

            let counterCheckedTeammember = 0;
            for (let i = 0; i < availablePlayerContainer.length; i++) {
                let checkbox = availablePlayerContainer[i].childNodes[0];

                if (checkbox !== undefined && checkbox.checked) {
                    counterCheckedTeammember++;
                    choosenTeamMembers.push(Number(checkbox.id));
                }
            }

            if (counterCheckedTeammember > 5) {
                this.textErrorMessage = 'Cannot add more than five teammember!';
                return;
            } else if (counterCheckedTeammember === 5) {
                /** Start server.js and databank for a functional get-request
                 *  Calculate Elo-Points, if team is complete
                 */
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

                        return calculatedEloPoints;
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            } else if (counterCheckedTeammember < 5) {
                eloPointsTeam += 1;

                // Push null-value into array to prevent error of undefined teammembers
                let durationLoop = 5 - choosenTeamMembers.length;
                for (let i = 0; i < durationLoop; i++) {
                    choosenTeamMembers.push(null);
                }
            } else {
                this.textErrorMessage = '';
            }

            if (teamname.length === 0) {
                this.textErrorMessage = 'Please fill out the entire form!';
                this.textSuccessMessage = '';
                return;
            } else {
                this.textErrorMessage = '';
            }

            // Start server.js and databank for a functional post-request
            fetch('http://localhost:3000/createNewTeam', {
                method: 'POST',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    newTeamname: teamname,
                    newEloPoints: eloPointsTeam,
                    firstMember: choosenTeamMembers[0],
                    secondMember: choosenTeamMembers[1],
                    thirdMember: choosenTeamMembers[2],
                    fourthMember: choosenTeamMembers[3],
                    fifthMember: choosenTeamMembers[4],
                }),
            })
                .then(response => {
                    if (response.ok) {
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
            /** Start server.js and databank for a functional post-request
             *  Display all available player-IDs in the select-option-field
             */
            fetch('http://localhost:3000/getActivePlayer')
                .then(response => response.json())
                .then(activePlayerData => {
                    let activePlayerIDs = [];
                    let activePlayernames = [];

                    for (let i = 0; i < activePlayerData.length; i++) {
                        activePlayerIDs.push(activePlayerData[i].playerID);
                        activePlayernames.push(activePlayerData[i].playername);
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

                            for (let i = 0; i < activeTeammemberIDs.length; i++) {
                                for (let a = 0; a < activePlayerIDs.length; a++) {
                                    if (
                                        activeTeammemberIDs[i] !== activePlayerIDs[a] &&
                                        !availableTeammemberIDs.includes(activePlayerIDs[a]) &&
                                        !activeTeammemberIDs.includes(activePlayerIDs[a])
                                    ) {
                                        availableTeammemberIDs.push(activePlayerIDs[a]);
                                        availableTeammemberNames.push(activePlayernames[a]);
                                    }
                                }
                            }

                            if (availableTeammemberIDs.length === 0) {
                                document.getElementById('availabe-player').innerHTML = 'No player available!';
                            }

                            for (let i = 0; i < availableTeammemberIDs.length; i++) {
                                // Push data into array in order to display it with v-for
                                this.availablePlayer.push({
                                    id: availableTeammemberIDs[i],
                                    name: availableTeammemberNames[i],
                                });
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
