<template>
  <div class="player-pick">
    <label :for="player" class="label">Choose {{ player }}</label>
    <select v-model="selectedPlayer" :id="player" class="select">
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
    }
  }
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
