<template>
    <navigationBar></navigationBar>
    <div class="centered-container">
        <div class="buttons">
            <RouterLink to="/OneVsOne" class="button">Player vs Player</RouterLink>
            <RouterLink to="/TeamVsTeam" class="button">Team vs Team</RouterLink>
            <RouterLink to="/TeamTournament" class="button">Tournament</RouterLink>
            <RouterLink to="/SettingScreen" class="button">Settings</RouterLink>
        </div>
    </div>
    <footerBar></footerBar>
</template>

<script>
import navigationBar from './Atoms/navigationBar.vue';
import footerBar from './Atoms/footerBar.vue';

export default {
    name: 'HomeScreen',
    components: {
        navigationBar,
        footerBar,
    },
};
</script>

<style scoped>
/* Container für den gesamten Screen */
.centered-container {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    height: 100vh;
    background: var(--white);
    padding: 0 20px;
}

/* Container für die Buttons */
.buttons {
    display: flex;
    flex-direction: column;
    gap: 15px;
    text-align: center;
}

/* Allgemeine Button-Stile */
.button {
    display: inline-block;
    padding: 15px 25px;
    margin: 5px 0;
    background-color: var(--darkgrey);
    color: var(--white);
    font-size: 16px;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px var(--transparentblack);
    text-transform: uppercase;
}

/* Hover-Effekt für Buttons */
.button:hover {
    background-color: var(--hovergreen);
    transform: translateY(-4px);
    box-shadow: 0 6px 15px var(--transparentblack);
}

/* Fokus-Effekt für Accessibility */
.button:focus {
    outline: none;
    box-shadow: 0 0 0 2px var(--lightred);
}

/* Responsive Anpassungen */
@media (max-width: 768px) {
    .buttons {
        gap: 10px;
    }
    .button {
        font-size: 14px;
        padding: 12px 20px;
    }
}
</style>
