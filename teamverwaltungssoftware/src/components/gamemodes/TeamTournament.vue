<template>
  <h2> TEST </h2>
  <div class="selectTeams">
    <div v-for="(teamPair, matchIndex) in matches" :key="matchIndex">
      <TeamPicks :team="teamPair.teamOne" :availableTeams="availableTeams" @update:teamName="setTeam(teamPair.teamOne, $event)" />
      <TeamPicks :team="teamPair.teamTwo" :availableTeams="availableTeams" @update:teamName="setTeam(teamPair.teamTwo, $event)" />
      <button @click="setRandomWinner(teamPair.teamOne, teamPair.teamTwo)">Play Randomly</button>
      <div class="chooseWinner">
        <label for="chooseWinner">Choose Winner</label>
        <select v-model="chooseWinner">
          <option>{{ teams[teamPair.teamOne] }}</option>
          <option>{{ teams[teamPair.teamTwo] }}</option>
        </select>
        <button @click="setWinner(chooseWinner, teamPair.teamOne, teamPair.teamTwo)">Set Winner</button>
        <WinnerMessage v-if='winner' :winner="winner" :eloPoints="'reputation'"/> 
      </div>
    </div>
  </div>
  <RouterLink to="/">Back</RouterLink>
</template>

<script>
import { gameLogic } from '../GameLogic/GameLogic.js'
import TeamPicks from '../Atoms/TeamPicks.vue'
import WinnerMessage from '../Atoms/WinnerMessage.vue'

export default {
  name: 'TeamTournament',
  components: {
    TeamPicks,
    WinnerMessage,
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
      availableTeams: [],
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
      console.log("fetching teams...");
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
      this.teams[teamName] = selectedTeam;  
      console.log(`${teamName} set to: ${selectedTeam}`);
    },

    async setRandomWinner(teamOne, teamTwo) {
      if (this.teams[teamOne] && this.teams[teamTwo]) {
        const { winner, loser } = gameLogic(this.teams[teamOne], this.teams[teamTwo]);
        this.winner = winner;
        console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
        alert(`Game finished! Winner: ${winner}, Loser: ${loser}`);
        try {
          const response = await fetch('http://localhost:3000/updateWinner', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ winner, teamOne, teamTwo })
          });

          if (response.ok) {
            alert(`Spiel beendet! Gewinner: ${winner}`);
          } else {
            alert('Fehler beim Speichern des Ergebnisses');
          }
        } catch (error) {
          console.error('Fehler beim Senden des Ergebnisses:', error.message);
        }
      } else {
        alert('Please select both players.');
      }
    },

    async setWinner(winner, teamOne, teamTwo) {   
      if (!winner) {
        alert("Please choose a winner!");
        return;
      }
      console.log('Winner:', winner, 'TeamOne:', teamOne, 'TeamTwo:', teamTwo); // Debugging
      try {
        const response = await fetch('http://localhost:3000/updateWinner', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ winner, teamOne, teamTwo }),
        });

        console.log('Response status:', response.status); // Debugging
        if (response.ok) {
          alert(`Spiel beendet! Gewinner: ${winner}`);
        } else {
          const errorDetails = await response.json();
          console.error('Fehler beim Speichern des Ergebnisses:', errorDetails);
          alert(`Fehler: ${errorDetails.message || 'Unbekannter Fehler'}`);
        }
      } catch (error) {
        console.error('Fehler beim Senden des Ergebnisses:', error.message);
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
