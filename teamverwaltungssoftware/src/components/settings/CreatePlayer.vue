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
            this.textSuccessMessage = '';

            let playername = document.getElementById('playername').value;
            let firstname = document.getElementById('firstname').value;
            let lastname = document.getElementById('lastname').value;
            let email = document.getElementById('email').value;
            let selectElement = document.getElementById('position');
            let position = selectElement.options[selectElement.selectedIndex].value;
            let eloPoints = document.getElementById('eloPoints').value;

            if (
                playername.length === 0 ||
                firstname.length === 0 ||
                lastname.length === 0 ||
                email.length === 0 ||
                eloPoints.length === 0
            ) {
                this.textErrorMessage = 'Please fill out the entire form!';
                return;
            } else {
                this.textErrorMessage = '';

                if (eloPoints > 4000) {
                    this.textErrorMessage = 'Maximum Elo-Points are 4000';
                    return;
                }

                let playernameExists = await fetch('http://localhost:3000/getPlayer')
                    .then(response => response.json())
                    .then(data => {
                        for (let i = 0; i < data.length; i++) {
                            if (playername === data[i].playername) {
                                return true;
                            }
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });

                if (playernameExists) {
                    this.textErrorMessage = 'Playername already exists!';
                    return;
                }

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
                    .then(response => {
                        if (response.ok) {
                            let createPlayerForm = document.getElementById('createPlayerForm').childNodes;

                            // Set Values of user input to default
                            createPlayerForm[1].value = '';
                            createPlayerForm[3].value = '';
                            createPlayerForm[5].value = '';
                            createPlayerForm[7].value = '';
                            createPlayerForm[11].value = '';

                            this.textSuccessMessage = 'Added new player successfully!';
                            return response.json();
                        }
                    })
                    .catch(error => {
                        console.error(error);
                        return;
                    });
            }
        },
    },
};
</script>

<template>
    <h1>Create a new player</h1>
    <form class="createPlayerForm" id="createPlayerForm">
        <label for="playername">Playername:</label>
        <input type="text" id="playername" name="playername" />
        <label for="firstname">firstname:</label>
        <input type="text" id="firstname" name="firstname" />
        <label for="lastname">lastname:</label>
        <input type="text" id="lastname" name="lastname" />
        <label for="email">E-Mail:</label>
        <input type="email" id="email" name="email" />
        <label for="position">Position:</label>
        <select id="position" name="position">
            <option value="Top-Lane">Top-Lane</option>
            <option value="Jungle">Jungle</option>
            <option value="Mid-lane">Mid-lane</option>
            <option value="Bot-Lane">Bot-Lane</option>
            <option value="Support">Support</option>
        </select>
        <label for="eloPoints">Elo-Points:</label>
        <input type="number" min="0" max="4000" id="eloPoints" name="eloPoints" />
        <button type="button" @click="saveNewPlayer">Save player</button>
    </form>
    <span class="success-message"> {{ textSuccessMessage }}</span>
    <span class="error-message">{{ textErrorMessage }}</span>
    <RouterLink to="/PlayerSettings"> Back </RouterLink>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.createPlayerForm {
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
