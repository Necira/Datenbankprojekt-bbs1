
<template>
  <div class="playerPick">
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
    }
  },
  watch: {
    selectedPlayer(newPlayer) {
      this.$emit('update:playerName', newPlayer);  
    }
  }
};
</script>

<style scoped>
.playerPick {
  margin: 10px;
}

select {
  padding: 5px;
}
</style>
