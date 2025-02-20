<template>
    <navigationBar></navigationBar>
    <div class="home-container">
        <div class="leaderboard-container">
            <playerLeaderboard></playerLeaderboard>
            <teamLeaderboard></teamLeaderboard>
        </div>
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
import playerLeaderboard from './Atoms/playerLeaderboard.vue';
import teamLeaderboard from './Atoms/teamLeaderboard.vue';
import navigationBar from './Atoms/navigationBar.vue';
import footerBar from './Atoms/footerBar.vue';

export default {
    name: 'HomeScreen',
    components: {
        playerLeaderboard,
        teamLeaderboard,
        navigationBar,
        footerBar,
    },
};
</script>

<style scoped>
/* Container für den gesamten Screen */
.home-container {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    height: 100vh;
    background: #f7f7f7;
    padding: 0 20px;
    font-family: 'Arial', sans-serif;
}

.leaderboard-container {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 40px;
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
    background-color: #2d2d2d;
    color: #fff;
    font-size: 16px;
    font-weight: 500;
    border-radius: 25px;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    text-transform: uppercase;
}

/* Hover-Effekt für Buttons */
.button:hover {
    background-color: #5d5d5d;
    transform: translateY(-4px);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

/* Fokus-Effekt für Accessibility */
.button:focus {
    outline: none;
    box-shadow: 0 0 0 2px #ff6f61;
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
