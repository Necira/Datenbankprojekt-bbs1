<template>
    <div>
        <div v-for="stat in playerStats" :key="player.playerID" :value="player" class="stats"></div>
        <div v-for="team in availableTeams" :key="player.playerID" :value="team.teamname"></div>
    </div>
</template>

<script>
export default {
    name: 'PlayerPicks',
    props: {
        player: String,
        playerStats: Array,
        stats: Array,
    },
    data() {},
    watch: {
        selectedPlayer(newPlayer) {
            this.$emit('update:playerName', newPlayer);
        },
    },
};
</script>

<style scoped>
/* Responsive Anpassungen für Tablets*/
@media only screen and (min-width: 768px) and (max-width: 1023px) {
}

/* Responsive Anpassungen für smartphone*/
@media only screen and (max-width: 767px) {
}
</style>
