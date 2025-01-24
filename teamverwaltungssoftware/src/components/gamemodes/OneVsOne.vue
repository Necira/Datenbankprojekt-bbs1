<template>
  <div class="buttons">
    <div class="playerOne">
      <label for="playerOne">Player One</label>
      <select v-model="playerOne" id="playerOne">
        <option v-for="player in availablePlayer" :key="player.id" :value="player.playername">
        {{ player.playername }}
        </option>
      </select>
    </div>
    <div class="playerTwo">
      <label for="playerTwo">Player Two</label>
        <select v-model="playerTwo" id="playerTwo">
          <option v-for="player in availablePlayer" :key="player.id" :value="player.playername">
          {{ player.playername }}
          </option>
        </select>
    </div>
    <button @click="startGame" v-if="!winner"> Play Randomly </button>
    <div class="chooseWinner">
    <label for="chooseWinner">choose Winner</label>
        <select v-model="chooseWinner" id="chooseWinner">
          <option>
            {{ playerOne }}
          </option>
          <option>
            {{ playerTwo }}
          </option>
        </select>
        <button @click="setWinner(chooseWinner)"> set winner </button>
        <h1 v-if="winner"> {{winner}} won </h1>
      </div>
  </div>
  <RouterLink to="/"> Back </RouterLink>
</template>

<script>
import {gameLogic} from '../GameLogic/GameLogic.js'
export default {
  name: 'OneVsOne',
  data() {
    return {
      playerOne: '', 
      playerTwo: '', 
      availablePlayer: [],
      winner: '',
    };
  },
  created() {
    this.fetchPlayers(); 
  },
  methods: {
    async fetchPlayers() {
      try {
        const response = await fetch('http://localhost:3000/getActivePlayer');
        const data = await response.json();
        console.log('Fetched players:', data); 
        this.availablePlayer = data; 
      } catch (error) {
        console.error('Error fetching players:', error.message);
      }
    },
    async setWinner(winner) {
      if (this.playerOne != this.playerTwo && this.playerOne && this.playerTwo) {
        let loser = '';
        if (winner) {
          if (winner === this.playerOne) {
            loser = this.playerTwo;
          } else {
            loser =  this.playerOne;
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
        alert('Choose two different players and no dublicates');
      }
    },
    async startGame() {
      if (this.playerOne && this.playerTwo && this.playerOne != this.playerTwo) {
        const { winner, loser } = gameLogic(this.playerOne, this.playerTwo);
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
}

</script>

<style scoped>
.buttons {
  display: flex;
  justify-content: center;
  flex-direction: column;
  margin: 30px;
}

.playerOne {
  display: flex;
  justify-content: center;
  margin: 10px;
}

.playerTwo {
  display: flex;
  justify-content: center;
  margin: 10px;
}

</style>
