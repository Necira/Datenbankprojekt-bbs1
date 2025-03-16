<template>
  <div v-if="isCurrentRound" class="round">
      <h3>Round {{ roundIndex + 1 }}</h3>
      <div v-for="(match, matchIndex) in matches" :key="'match-' + matchIndex" class="match">
          <div class="teams">
              <p v-if="!isFirstRound">{{ match.teamOne }}</p>
              <select v-else v-model="match.teamOne" class="dropdown">
                  <option v-for="team in availableTeams" :key="team" :value="team">{{ team }}</option>
              </select>

              <p>vs</p>

              <p v-if="!isFirstRound">{{ match.teamTwo }}</p>
              <select v-else v-model="match.teamTwo" class="dropdown">
                  <option v-for="team in availableTeams" :key="team" :value="team">{{ team }}</option>
              </select>
          </div>
          <div class="actions">
              
              <div class="chooseWinner">
                  <label for="chooseWinner">Choose Winner</label>
                  <select v-model="match.winner" class="dropdown">
                      <option v-if="match.teamOne" :value="match.teamOne">{{ match.teamOne }}</option>
                      <option v-if="match.teamTwo" :value="match.teamTwo">{{ match.teamTwo }}</option>
                  </select>
              </div>
          </div>
      </div>
      <button v-if="allWinnersSelected" @click="setAllWinners" class="set-winners">Set Winners</button>
  </div>
</template>

<script>

export default {
  name: 'TournamentRound',
  props: {
      roundIndex: Number,
      matches: Array,
      availableTeams: Array,
      isFirstRound: Boolean,
      isCurrentRound: Boolean,
  },
  computed: {
      allWinnersSelected() {
          return this.matches.every(match => match.winner);
      }
  },
  methods: {
      setAllWinners() {
          const winners = this.matches.map(match => match.winner);
          this.$emit('setWinners', winners, this.roundIndex);
      }
  },
};
</script>

<style scoped>
.round {
  margin-bottom: 30px;
  padding: 20px;
  background-color: var(--white);
  border-radius: 12px;
  box-shadow: 0 4px 6px var(--transparentblack);
}
.match {
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.teams {
  display: flex;
  justify-content: center;
  gap: 20px;
  font-weight: bold;
}
.actions {
  margin-top: 10px;
}
.set-winner {
  padding: 10px 15px;
  font-size: 14px;
  font-weight: bold;
  color: white;
  background-color: var(--blue);
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}
.set-winner:hover {
  background-color: var(--hoverblue);
}
.chooseWinner {
  margin-top: 10px;
}
.dropdown {
  padding: 8px;
  border: 1px solid var(--lightgrey);
  border-radius: 6px;
  margin-right: 10px;
}
.set-winners {
  margin-top: 20px;
  padding: 10px 20px;
  font-size: 16px;
  font-weight: bold;
  color: white;
  background-color: var(--green);
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}
.set-winners:hover {
  background-color: var(--hovergreen);
}

label {
  padding-right: 20px;
}
</style>