<template>
    <h1>Create a new team</h1>
    <form class="create-team-form">
        <label for="teamname">teamname</label>
        <input id="teamname" name="teamname" />
        <label for="eloPoints">elo-points</label>
        <input id="eloPoints" name="eloPoints" type="number" min="0" />
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
</style>
