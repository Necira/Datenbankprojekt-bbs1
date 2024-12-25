<script>
export default {
    data() {
        return {
            name: 'CreatePlayer',
            textErrorMessage: '',
            textSuccessMessage: '',
        };
    },
    methods: {
        async saveNewPlayer() {
            let playername = document.getElementById('playername').value;
            let firstname = document.getElementById('firstname').value;
            let lastname = document.getElementById('lastname').value;
            let email = document.getElementById('email').value;
            let position = document.getElementById('position').value;
            let eloPoints = document.getElementById('eloPoints').value;

            if (
                playername.length === 0 ||
                firstname.length === 0 ||
                lastname.length === 0 ||
                email.length === 0 ||
                position.length === 0 ||
                eloPoints.length === 0
            ) {
                this.textErrorMessage = 'Please fill out the entire form!';
                return;
            } else {
                this.textErrorMessage = '';

                const regExEmail = /^[a-z0-9.]+@[a-z]+\.[a-z]{2,4}$/;
                if (!email.match(regExEmail)) {
                    this.textErrorMessage = 'Invalid E-mail!';
                    return;
                }

                let splittedFirstname = firstname.split('');
                let splittedLastname = lastname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedFirstname.length; i++) {
                    if (!splittedFirstname[i].match(onlyLettersRegEx)) {
                        this.textErrorMessage = 'Invalid firstname!';
                        return;
                    }
                }

                for (let i = 0; i < splittedLastname.length; i++) {
                    if (!splittedLastname[i].match(onlyLettersRegEx)) {
                        this.textErrorMessage = 'Invalid lastname!';
                        return;
                    }
                }

                // Start server.js and databank for a functional post-request
                fetch('http://localhost:3000/createNewPlayer', {
                    method: 'POST',
                    headers: {
                        'Access-Control-Allow-Origin': '*',
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        newPlayername: playername,
                        newFirstname: firstname,
                        newLastname: lastname,
                        newEmail: email,
                        newPosition: position,
                        newEloPoints: eloPoints,
                    }),
                })
                    .then(response => response.json())
                    .catch(error => {
                        console.error(error);
                        return;
                    });

                this.textSuccessMessage = 'Added new player successfully!';
                console.log('test');
            }
        },
    },
};
</script>

<template>
    <h1>Create a new player</h1>
    <form class="create-player-form">
        <label for="playername">Playername:</label>
        <input type="text" id="playername" name="playername" />
        <label for="firstname">firstname:</label>
        <input type="text" id="firstname" name="firstname" />
        <label for="lastname">lastname:</label>
        <input type="text" id="lastname" name="lastname" />
        <label for="email">E-Mail:</label>
        <input type="email" id="email" name="email" />
        <label for="position">Position:</label>
        <input type="text" id="position" name="position" />
        <label for="eloPoints">Elo-Points:</label>
        <input type="number" min="0" id="eloPoints" name="eloPoints" />
        <button type="button" @click="saveNewPlayer">Save player</button>
    </form>
    <span class="success-message"> {{ textSuccessMessage }}</span>
    <span class="error-message">{{ textErrorMessage }}</span>
    <RouterLink to="/PlayerSettings"> Back </RouterLink>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.create-player-form {
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
