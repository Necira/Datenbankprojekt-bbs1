<template>
  <div class="selectTeams">
    <div v-for="(teamPair, matchIndex) in matches" :key="matchIndex">
      <TeamPicks :team="teamPair.teamOne" @update:teamName="setTeam(teamPair.teamOne, $event)" />
      <TeamPicks :team="teamPair.teamTwo" @update:teamName="setTeam(teamPair.teamTwo, $event)" />
      <button @click="startGame(teamPair.teamOne, teamPair.teamTwo)">Play Randomly</button>
      <div class="chooseWinner">
        <label for="chooseWinner">Choose Winner</label>
        <select v-model="chooseWinner">
          <option>{{ teams[teamPair.teamOne] }}</option>
          <option>{{ teams[teamPair.teamTwo] }}</option>
        </select>
        <button @click="setWinner(chooseWinner)">Set Winner</button>
        <h1 v-if="winner">{{ winner }} won</h1>
      </div>
    </div>

  </div>
  <RouterLink to="/">Back</RouterLink>
</template>

<script>
import { gameLogic } from '../GameLogic/GameLogic.js'
import TeamPicks from '../Molecules/TeamPicks.vue';

export default {
  name: 'TournamentMode',
  components: {
    TeamPicks,
  },
  data() {
    return {
      teams: {
        teamOne: '',
        teamTwo: '',
        teamThree: '',
        teamFour: '',
        teamFive: '',
        teamSix: '',
        teamSeven: '',
        teamEight: ''
      },
      winner: '',
      chooseWinner: '',
      matches: [
        { teamOne: 'teamOne', teamTwo: 'teamTwo' },
        { teamOne: 'teamThree', teamTwo: 'teamFour' },
        { teamOne: 'teamFive', teamTwo: 'teamSix' },
        { teamOne: 'teamSeven', teamTwo: 'teamEight' },
      ]
    };
  },
  created() {
    this.fetchteams(); 
  },
  methods: {
    async fetchteams() {
      try {
        const response = await fetch('http://localhost:3000/getActiveteams');
        const data = await response.json();
        console.log('Fetched teams:', data); 
      } catch (error) {
        console.error('Error fetching teams:', error.message);
      }
    },
    
    setTeam(teamName, selectedTeam) {
      this.$set(this.teams, teamName, selectedTeam);
      console.log(`${teamName} set to: ${selectedTeam}`);
    },

    startGame(teamOne, teamTwo) {
      if (this.teams[teamOne] && this.teams[teamTwo]) {
        const { winner, loser } = gameLogic(this.teams[teamOne], this.teams[teamTwo]);
        this.winner = winner;
        console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
        alert(`Game finished! Winner: ${winner}, Loser: ${loser}`);
      } else {
        alert('Please select both players.');
      }
    },

    async setWinner(winner) {
      const loser = winner === this.teams.teamOne ? this.teams.teamTwo : this.teams.teamOne;
      
      if (!winner) {
        alert("Please choose a winner!");
        return;
      }
      
      try {
        await fetch('http://localhost:3000/updateElo', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ winner, loser })
        });
        console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
        alert(`Game finished! Winner: ${winner}, Loser: ${loser}`);
      } catch (error) {
        console.error('Error updating Elo points:', error.message);
      }
    },
  }
};
</script>

<style scoped>
.selectTeams {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.chooseWinner {
  margin-top: 10px;
}

button {
  margin: 10px;
}
</style>
