<template>
  <div>
    <div
      v-for="stat in playerStats"
      :key="player.playerID"
      :value="player"
      class="stats"
    ></div>
    <div
      v-for="team in availableTeams"
      :key="player.playerID"
      :value="team.teamname"
    ></div>
  </div>
</template>

<script>
export default {
  name: "PlayerPicks",
  props: {
    player: String,
    playerStats: Array,
    stats: Array,
  },
  watch: {
    selectedPlayer(newPlayer) {
      this.$emit("update:playerName", newPlayer);
    },
  },
};
</script>

<style scoped></style>
