<template>
  <div class="buttons">
    <div class="teamOne">
      <label for="teamOne">team one</label>
      <select v-model="teamOne" id="teamOne">
        <option v-for="team in availableteam" :key="team.id" :value="team.teamname">
        {{ team.teamname }}
        </option>
      </select>
     <button @click="setteamOne(teamOne)"> Set team one </button>
    </div>
    <div class="teamTwo">
      <label for="teamTwo">team two</label>
        <select v-model="teamTwo" id="teamTwo">
          <option v-for="team in availableteam" :key="team.id" :value="team.teamname">
          {{ team.teamname }}
          </option>
        </select>
      <button @click="setteamTwo(teamTwo)"> Set team two </button>
    </div>
    <button @click="startGame"> Play Randomly </button>
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
        <h1 v-if="winner"> {{winner}} won </h1>
      </div>
  </div>
  <RouterLink to="/"> Back </RouterLink>
</template>

<script>
import axios from 'axios';
import {gameLogic} from '../GameLogic/GameLogic.js'
export default {
  name: 'TeamVsTeam',
  data() {
    return {
      teamOne: '', 
      teamTwo: '', 
      availableteam: [],
      winner: '',
    };
  },
  created() {
    this.fetchteams(); 
  },
  methods: {
    async fetchteams() {
      try {
        const response = await axios.get('http://localhost:3000/getActiveteams'); 
        console.log('Fetched teams:', response.data); 
        this.availableteam = response.data; 
      } catch (error) {
        console.error('Error fetching teams:', error.message);
      }
    },
    setteamOne(teamName) {
      this.teamOne = teamName; 
      console.log(`team one set to: ${teamName}`);
    },
    setteamTwo(teamName) {
      this.teamTwo = teamName;
      console.log(`team two set to: ${teamName}`);
    },
    async setWinner(winner) {
      if (this.teamOne != this.teamTwo) {
     
      let loser = '';
      if (winner) {
        if (winner === this.teamOne) {
          loser = this.teamTwo;
        } else {
          loser =  this.teamOne;
        }
      } else {
        alert("nice try..choose Winner!! ;)")
      }
      try {
          await axios.post('http://localhost:3000/updateElo', { winner, loser });

          console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
          alert(`Game finished! Winner: ${winner}, Loser: ${loser}`);
        } catch (error) {
          console.error('Error updating Elo points:', error.message);
        }
        this.winner = winner
        } else {(`choose two different teams`);
          alert
        }
      },
    async startGame() {
      if (this.teamOne && this.teamTwo) {
        const { winner, loser } = gameLogic(this.teamOne, this.teamTwo);
        try {

          await axios.post('http://localhost:3000/updateElo', { winner, loser });

          console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
          alert(`Game finished! Winner: ${winner}, Loser: ${loser}`);
        } catch (error) {
          console.error('Error updating Elo points:', error.message);
        }
      } else {
        alert('Please select both players.');
      }
    }
  }
};
</script>

<style scoped>

</style>
