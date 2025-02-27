<template>
    <navigationBar></navigationBar>
    <div class="centered-container">
        <div class="leaderboard-container">
            <playerLeaderboard></playerLeaderboard>
            <teamLeaderboard></teamLeaderboard>
        </div>
        <RouterLink to="/" class="homescreen-routerlink">← Back to Home</RouterLink>
    </div>
    <footerBar></footerBar>
</template>

<script>
import navigationBar from './Atoms/navigationBar.vue';
import footerBar from './Atoms/footerBar.vue';
import playerLeaderboard from './Atoms/playerLeaderboard.vue';
import teamLeaderboard from './Atoms/teamLeaderboard.vue';

export default {
    components: {
        navigationBar,
        footerBar,
        playerLeaderboard,
        teamLeaderboard,
    },
    name: 'LeaderboardScreen',
};
</script>

<style scoped>
.leaderboard-container {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 40px;
}

.centered-container {
    margin: 0 auto;
    width: 500px;
    display: flex;
    flex-direction: column;
}

.homescreen-routerlink {
    font-size: 16px;
    color: var(--blue);
    text-decoration: none;
    font-weight: bold;
    margin-top: 20px;
    transition: color 0.3s ease, transform 0.2s ease;
}

.homescreen-routerlink:hover {
    color: var(--hoverblue);
    transform: scale(1.05);
}
</style>
