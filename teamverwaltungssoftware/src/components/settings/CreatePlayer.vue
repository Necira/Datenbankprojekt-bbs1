<script>
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    components: {
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
        <span class="success-message"> {{ successMessage }}</span>
        <span class="error-message">{{ errorMessage }}</span>
        <button type="button" class="save-player" @click="validateForm">Save player</button>
    </form>
    <RouterLink to="/PlayerSettings" class="back">← Back </RouterLink>
    <footerBar></footerBar>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.createPlayerForm {
    width: 400px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.error-message {
    color: var(--red);
    font-size: 20px;
}

.success-message {
    color: var(--green);
    font-size: 20px;
}

.back {
    font-size: 16px;
    color: var(--blue);
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: color 0.3s ease, transform 0.2s ease;
}

.back:hover {
    color: var(--hoverblue);
    transform: scale(1.05);
}

label {
    margin-bottom: 8px;
    font-size: 16px;
    color: var(--black);
    font-weight: 500;
}

select,
input {
    width: 100%;
    max-width: 300px;
    padding: 10px;
    font-size: 16px;
    color: var(--black);
    border: 1px solid var(--lightgrey);
    border-radius: 8px;
    background-color: var(--white);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
    margin-bottom: 10px;
}

select:hover,
input:hover {
    border-color: var(--black);
}

select:focus,
input:focus {
    outline: none;
    border-color: var(--blue);
    box-shadow: 0 0 5px var(--transparentblue);
}

.save-player {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
    background-color: var(--darkgrey);
    color: var(--white);
    font-size: 16px;
    border: none;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px var(--transparentblack);
    text-transform: uppercase;
    margin-left: 135px;
    margin-bottom: 15px;
}

.save-player:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    select,
    input {
        padding: 5px;
        font-size: 14px;
    }

    label {
        font-size: 15px;
    }

    .createPlayerForm {
        width: 300px;
    }

    .save-player {
        padding: 10px 10px;
        font-size: 13px;
        margin-left: 104px;
    }

    h1 {
        font-size: 20px;
    }

    .error-message,
    .success-message {
        font-size: 15px;
    }
}
</style>
