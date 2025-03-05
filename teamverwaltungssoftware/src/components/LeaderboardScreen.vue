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
    methods: {
        indicateCurrentPage() {
            let activeRouterlink = document.getElementById('leaderboard-routerlink');
            activeRouterlink.style.backgroundColor = 'var(--hovergreen)';
        },
    },
    mounted() {
        this.indicateCurrentPage();
    },
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
    align-items: center;
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

/* Responsive Anpassungen für Tablets*/
/* @media only screen and (min-width: 768px) and (max-width: 1023px) {
} */

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
    .leaderboard-container {
        flex-direction: column;
    }

    .centered-container {
        width: 100%;
    }
}
</style>
