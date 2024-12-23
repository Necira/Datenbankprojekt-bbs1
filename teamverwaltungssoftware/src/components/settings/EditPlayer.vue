<template>
    <h1>Edit existing player</h1>
    <form class="edit-player-form">
        <label for="playername">Playername:</label>
        <select id="playername" name="playername">
            <!-- TO-DO: Add each player -->
            <option>test1</option>
        </select>
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
        <button type="button" @click="editPlayer">Edit player</button>
    </form>
    <span class="error-message">{{ textErrorMessage }}</span>
    <button type="button" @click="openAndClosePopUpWindow">Delete player</button>
    <RouterLink to="/PlayerSettings"> Back </RouterLink>

    <div id="popUp-Window" v-if="openPoPUpWindow">
        <button type="button" class="close-PopUpWindow" @click="openAndClosePopUpWindow">X</button>
        <div class="column">
            <label for="playername">Chosse a player:</label>
            <select id="playername" name="playername">
                <!-- TO-DO: Add each player -->
                <option>test1</option>
            </select>
            <button type="button" @click="deletePlayer">Delete player</button>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            name: 'EditPlayer',
            textErrorMessage: '',
            openPoPUpWindow: false,
        };
    },
    methods: {
        deletePlayer() {
            console.log('delete player');
        },
        openAndClosePopUpWindow() {
            this.openPoPUpWindow = !this.openPoPUpWindow;
            console.log(this.openPoPUpWindow);
        },
        editPlayer() {
            console.log('edit player');
            // let playername = document.getElementById('playername').value;
            let firstname = document.getElementById('firstname').value;
            let lastname = document.getElementById('lastname').value;
            let email = document.getElementById('email').value;
            let position = document.getElementById('position').value;
            let eloPoints = document.getElementById('eloPoints').value;

            if (
                // playername.length === 0 &&
                firstname.length === 0 &&
                lastname.length === 0 &&
                email.length === 0 &&
                position.length === 0 &&
                eloPoints.length === 0
            ) {
                this.textErrorMessage = 'Please fill out at least one form field!';
                return;
            } else {
                this.textErrorMessage = '';
            }

            if (firstname.length > 0) {
                let splittedFirstname = firstname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedFirstname.length; i++) {
                    if (!splittedFirstname[i].match(onlyLettersRegEx)) {
                        this.textErrorMessage = 'Invalid firstname!';
                        return;
                    }
                }
            } else {
                this.textErrorMessage = '';
            }

            if (lastname.length > 0) {
                let splittedLastname = lastname.split('');
                const onlyLettersRegEx = /^[a-zA-Z]+$/;

                for (let i = 0; i < splittedLastname.length; i++) {
                    if (!splittedLastname[i].match(onlyLettersRegEx)) {
                        this.textErrorMessage = 'Invalid lastname!';
                        return;
                    }
                }
            } else {
                this.textErrorMessage = '';
            }

            if (email.length > 0) {
                const regExEmail = /^[a-z0-9.]+@[a-z]+\.[a-z]{2,4}$/;
                if (!email.match(regExEmail)) {
                    this.textErrorMessage = 'Invalid E-mail!';
                    return;
                }
            } else {
                this.textErrorMessage = '';
            }
        },
    },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.edit-player-form {
    display: flex;
    justify-content: center;
    flex-direction: column;
}

.error-message {
    color: red;
    font-size: 20px;
}

#popUp-Window {
    background-color: aquamarine;
    padding: 15px;
    position: fixed;
    margin: auto 0;
    left: 45%;
    bottom: 50%;
}

.column {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.close-PopUpWindow {
    display: flex;
}
</style>
