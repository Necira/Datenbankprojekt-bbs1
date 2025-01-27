<template>
  <div class="buttons">
    <TeamPicks :team="teamOne" :availableTeams="availableTeams" @update:teamName="setTeam('teamOne', $event)" />
    <TeamPicks :team="teamTwo" :availableTeams="availableTeams" @update:teamName="setTeam('teamTwo', $event)" />
  </div>
  <button @click="setRandomWinner"> Play Randomly </button>
  <div class="chooseWinner">
    <label for="chooseWinner">choose Winner</label>
      <select v-model="chooseWinner" id="chooseWinner">
        <option>
          {{ teamOne }}
        </option>
        <option>
          {{ teamTwo }}
        </option>
      </select>
      <button @click="setWinner(chooseWinner)"> set winner </button>
      <WinnerMessage v-if='winner' :winner="winner" :eloPoints="eloPoints"/> 
    <RouterLink to="/"> Back </RouterLink>
  </div>
</template>

<script>
import {gameLogic} from '../GameLogic/GameLogic.js'
import TeamPicks from '../Atoms/TeamPicks.vue'
import WinnerMessage from '../Atoms/WinnerMessage.vue'

export default {
  components: {
    TeamPicks,
    WinnerMessage,
  },
  name: 'TeamVsTeam',
  data() {
    return {
      teamOne: '', 
      teamTwo: '', 
      availableTeams: [],
      winner: '',
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
        this.availableTeams = data; 
      } catch (error) {
        console.error('Error fetching teams:', error.message);
      }
    },
    setTeam(teamName, selectedTeam) {
      if (teamName === 'teamOne') {
        this.teamOne = selectedTeam;
      } else if (teamName === 'teamTwo') {
        this.teamTwo = selectedTeam;
      }
      console.log(`${teamName} set to: ${selectedTeam}`);
    },
    async setWinner(winner) {
      if (this.teamOne && this.teamTwo && this.teamOne != this.teamTwo) {
        let loser = '';
        if (winner) {
          if (winner === this.teamOne) {
            loser = this.teamTwo;
          } else {
            loser = this.teamOne;
          }
        } else {
          alert("nice try..choose Winner!! ;)")
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
        this.winner = winner
        } else {
          alert('Choose two different teams');
        }
      },
    async setRandomWinner() {
      if (this.teamOne && this.teamTwo && this.teamOne != this.teamTwo) {
        const { winner, loser } = gameLogic(this.teamOne, this.teamTwo);
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
      } else {
        alert('Please select both players and no dublicates.');
      }
    }
  }
};
</script>

<style scoped>
.buttons {
  display: flex;
  justify-content: center;
  flex-direction: column;
  margin: 30px;
}

.teamOne {
  display: flex;
  justify-content: center;
  margin: 10px;
}

.teamTwo {
  display: flex;
  justify-content: center;
  margin: 10px;
}

</style>
