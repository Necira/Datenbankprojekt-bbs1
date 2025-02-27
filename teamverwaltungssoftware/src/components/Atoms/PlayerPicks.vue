<template>
    <div class="player-pick">
        <label :for="player">Choose {{ player }}</label>
        <select v-model="selectedPlayer" :id="player">
            <option v-for="player in availablePlayers" :key="player.playerID" :value="player.playername">
                {{ player.playername }}
            </option>
        </select>
    </div>
</template>

<script>
export default {
    name: 'PlayerPicks',
    props: {
        player: String,
        availablePlayers: Array,
    },
    data() {
        return {
            selectedPlayer: '',
        };
    },
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
}

label {
    margin-bottom: 8px;
    font-size: 16px;
    color: var(--black);
    font-weight: 500;
}

select {
    width: 100%;
    max-width: 300px;
    padding: 10px;
    font-size: 16px;
    color: var(--black);
    border: 1px solid var(--lightgrey);
    border-radius: 8px;
    background-color: var(--white);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

select:hover {
    border-color: var(--black);
}

select:focus {
    outline: none;
    border-color: var(--blue);
    box-shadow: 0 0 5px var(--transparentblue);
}

option {
    font-size: 16px;
    padding: 8px;
}

@media (max-width: 768px) {
    select {
        font-size: 14px;
        padding: 8px;
    }
}
</style>
