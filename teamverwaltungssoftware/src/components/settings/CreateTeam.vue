<template>
    <h1>Create a new team</h1>
    <form class="create-team-form">
        <label for="teamname">teamname</label>
        <input id="teamname" name="teamname" />
        <label for="eloPoints">elo-points</label>
        <input id="eloPoints" name="eloPoints" type="number" min="0" />
        <label for="member">member</label>
        <div id="availabe-player"></div>
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
        };
    },
    methods: {
        saveNewTeam() {
            let teamname = document.getElementById('teamname').value;
            let eloPoints = document.getElementById('eloPoints').value;
            let availablePlayerContainer = document.getElementById('availabe-player').childNodes;
            let choosenTeamMembers = [];

            let counterCheckedTeammember = 0;
            for (let i = 0; i < availablePlayerContainer.length; i++) {
                let checkbox = availablePlayerContainer[i].childNodes[0];

                if (checkbox.checked) {
                    counterCheckedTeammember++;
                    choosenTeamMembers.push(Number(checkbox.id));
                }
            }

            if (counterCheckedTeammember > 5) {
                this.textErrorMessage = 'Cannot add more than five teammember!';
                return;
            } else if (counterCheckedTeammember < 5) {
                // Push null-value into array to prevent error of undefined teammembers
                let durationLoop = 5 - choosenTeamMembers.length;
                for (let i = 0; i < durationLoop; i++) {
                    choosenTeamMembers.push(null);
                }
            } else {
                this.textErrorMessage = '';
            }

            if (teamname.length === 0 || eloPoints.length === 0) {
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
                    newEloPoints: eloPoints,
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
                .then(data => {
                    for (let i = 0; i < data.length; i++) {
                        let container = document.createElement('div');
                        let availablePlayerCheckbox = document.createElement('input');
                        availablePlayerCheckbox.type = 'checkbox';
                        availablePlayerCheckbox.id = data[i].playerID;
                        let availablePlayerLabel = document.createElement('label');
                        availablePlayerLabel.innerHTML = data[i].playername;
                        container.appendChild(availablePlayerCheckbox);
                        container.appendChild(availablePlayerLabel);
                        document.getElementById('availabe-player').appendChild(container);
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
