<script>
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components:{
        navigationBar,
        footerBar,
    },
    data() {
        return {
            name: 'CreatePlayer',
            errorMessage: '',
            successMessage: '',
        };
    },
    methods: {
        async validateForm() {
            this.successMessage = '';

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
                this.errorMessage = 'Please fill out the entire form!';
                return;
            } else {
                this.errorMessage = '';

                if (eloPoints > 4000) {
                    this.errorMessage = 'Maximum Elo-Points are 4000';
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
                    this.errorMessage = 'Playername already exists!';
                    return;
                }

                const regExEmail = /^[a-z0-9.]+@[a-z]+\.[a-z]{2,4}$/;
                if (!email.match(regExEmail)) {
                    this.errorMessage = 'Invalid E-mail!';
                    return;
                }

                let splittedFirstname = firstname.split('');
                let splittedLastname = lastname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedFirstname.length; i++) {
                    if (!splittedFirstname[i].match(onlyLettersRegEx)) {
                        this.errorMessage = 'Invalid firstname!';
                        return;
                    }
                }

                for (let i = 0; i < splittedLastname.length; i++) {
                    if (!splittedLastname[i].match(onlyLettersRegEx)) {
                        this.errorMessage = 'Invalid lastname!';
                        return;
                    }
                }

                this.postNewPlayer(playername, firstname, lastname, email, position, eloPoints);
            }
        },
        async postNewPlayer(setPlayername, setFirstname, setLastname, setEmail, setPosition, setEloPoints) {
            fetch('http://localhost:3000/createNewPlayer', {
                method: 'POST',
                headers: {
                    'Access-Control-Allow-Origin': '*',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    newPlayername: setPlayername,
                    newFirstname: setFirstname,
                    newLastname: setLastname,
                    newEmail: setEmail,
                    newPosition: setPosition,
                    newEloPoints: setEloPoints,
                }),
            })
                .then(response => {
                    if (response.ok) {
                        console.log(
                            setPlayername,
                            setFirstname,
                            setLastname,
                            setEmail,
                            setPosition,
                            setEloPoints,
                        );
                        let createPlayerForm = document.getElementById('createPlayerForm').childNodes;

                        // Set Values of user input to default after player is created
                        createPlayerForm[1].value = '';
                        createPlayerForm[3].value = '';
                        createPlayerForm[5].value = '';
                        createPlayerForm[7].value = '';
                        createPlayerForm[11].value = '';

                        this.successMessage = 'Added new player successfully!';
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

<template>
    
    <navigationBar></navigationBar>
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
        <button type="button" @click="validateForm">Save player</button>
    </form>
    <span class="success-message"> {{ successMessage }}</span>
    <span class="error-message">{{ errorMessage }}</span>
    <RouterLink to="/PlayerSettings" class="back">← Back </RouterLink>
    <footerBar></footerBar>
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

.back {
    font-size: 16px;
    color: #007bff;
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: color 0.3s ease, transform 0.2s ease;
}

.back:hover {
    color: #0056b3;
    transform: scale(1.05);
}

</style>
