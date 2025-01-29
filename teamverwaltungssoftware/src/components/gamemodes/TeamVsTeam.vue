<template>
  <div class="team-vs-team">
    <div class="buttons">
      <TeamPicks 
        :team="teamOne" 
        :availableTeams="availableTeams" 
        @update:teamName="setTeam('teamOne', $event)" 
      />
      <TeamPicks 
        :team="teamTwo" 
        :availableTeams="availableTeams" 
        @update:teamName="setTeam('teamTwo', $event)" 
      />
    </div>
    <div class="message">
      {{ message }}
    </div>
    <div class="actions" v-if="teamOne && teamTwo && teamTwo != teamOne">
      <button class="play-randomly" @click="setRandomWinner">🎲 Play Randomly</button>
      <div class="choose-winner">
        <label for="chooseWinner">Choose Winner</label>
        <select v-model="chooseWinner" id="chooseWinner" class="dropdown">
          <option :value="teamOne">{{ teamOne }}</option>
          <option :value="teamTwo">{{ teamTwo }}</option>
        </select>
        <button class="set-winner" @click="setWinner(chooseWinner)">🏆 Set Winner</button>
      </div>
    </div>
    <WinnerMessage v-if="winner" :winner="winner" :eloPoints="eloPoints" />
    <RouterLink to="/" class="back-link">← Back</RouterLink>
  </div>
</template>


<script>
import {randomizer} from '../GameLogic/Randomizer.js'
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
      message: '',
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
      if (this.teamOne === this.teamTwo) {
        this.message = 'nice try.. select 2 different teams ;)'
      }  else {
        this.message = ''
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
          this.message ="nice try..choose Winner!!"
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
            this.message =`Game finished! Winner: ${winner}, Loser: ${loser}`;
          } catch (error) {
            console.error('Error updating Elo points:', error.message);
          }
        this.winner = winner
        } else {
          this.message ='Choose two different teams';
        }
      },
    async setRandomWinner() {
      if (this.teamOne && this.teamTwo && this.teamOne != this.teamTwo) {
        const { winner, loser } = randomizer(this.teamOne, this.teamTwo);
        try {

          await fetch('http://localhost:3000/updateElo', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ winner, loser })
          });

          console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
          this.message =`Game finished! Winner: ${winner}, Loser: ${loser}`;
        } catch (error) {
          console.error('Error updating Elo points:', error.message);
        }
      } else {
        this.message ='Please select both players and no dublicates.';
      }
    }
  }
};
</script>

<style scoped>
.team-vs-team {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 30px;
  font-family: 'Roboto', sans-serif;
  background-color: #f9f9f9;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  margin: 50px auto;
}

.buttons {
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 100%;
  max-width: 400px;
}

.actions {
  display: flex;
  flex-direction: column;
  gap: 20px;
  width: 100%;
  max-width: 400px;
}

.play-randomly {
  padding: 15px 25px;
  font-size: 18px;
  color: white;
  background-color: #4caf50;
  border: none;
  border-radius: 12px;
  font-weight: bold;
  text-transform: uppercase;
  cursor: pointer;
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.play-randomly:hover {
  background-color: #45a049;
  transform: scale(1.05);
}

.choose-winner label {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 5px;
  color: #333;
}

.dropdown {
  padding: 12px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 8px;
  background-color: white;
  width: 100%;
}

.set-winner {
  padding: 12px 20px;
  font-size: 16px;
  font-weight: bold;
  color: white;
  background-color: #007bff;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  text-transform: uppercase;
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.set-winner:hover {
  background-color: #0056b3;
  transform: scale(1.05);
}

.back-link {
  margin-top: 20px;
  font-size: 16px;
  color: #007bff;
  text-decoration: none;
  font-weight: bold;
  transition: color 0.3s ease, transform 0.2s ease;
}

.back-link:hover {
  color: #0056b3;
  transform: scale(1.05);
}
</style>
