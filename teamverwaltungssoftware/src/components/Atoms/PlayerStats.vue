<template>
    <div class="player-stats">
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
.player-pick {
    margin: 15px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    font-family: 'Arial', sans-serif;
}

.label {
    margin-bottom: 8px;
    font-size: 16px;
    color: #333;
    font-weight: 500;
}

.select {
    width: 100%;
    max-width: 300px;
    padding: 10px;
    font-size: 16px;
    color: #333;
    border: 1px solid #ccc;
    border-radius: 8px;
    background-color: #fff;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.select:hover {
    border-color: #888;
}

.select:focus {
    outline: none;
    border-color: #5d5dff;
    box-shadow: 0 0 5px rgba(93, 93, 255, 0.5);
}

option {
    font-size: 16px;
    padding: 8px;
}

@media (max-width: 768px) {
    .select {
        font-size: 14px;
        padding: 8px;
    }
}
</style>
