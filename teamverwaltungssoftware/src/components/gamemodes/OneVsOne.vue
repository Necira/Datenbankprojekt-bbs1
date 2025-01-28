<template>
  <div class="buttons">
    <div class="buttons">
      <PlayerPicks :player="playerOne" :availablePlayers="availablePlayers" @update:playerName="setPlayer('playerOne', $event)" />
      <PlayerPicks :player="playerTwo" :availablePlayers="availablePlayers" @update:playerName="setPlayer('playerTwo', $event)" />
    </div>
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
      <WinnerMessage v-if='winner' :winner="winner" :eloPoints="eloPoints"/> 
    </div>
  <RouterLink to="/"> Back </RouterLink>
</template>

<script>
import {randomizer} from '../GameLogic/Randomizer.js'
import PlayerPicks from '../Atoms/PlayerPicks.vue'
import WinnerMessage from '../Atoms/WinnerMessage.vue'

export default {
    components: {
      PlayerPicks,
      WinnerMessage,
    },
    name: 'OneVsOne',
    data() {
        return {
            playerOne: '',
            playerTwo: '',
            availablePlayers: [],
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
                this.availablePlayers = data;
            }
            catch (error) {
                console.error('Error fetching players:', error.message);
            }
        },
        setPlayer(playerName, selectedPlayer) {
          if (playerName === 'playerOne') {
            this.playerOne = selectedPlayer;
          } else if (playerName === 'playerTwo') {
            this.playerTwo = selectedPlayer;
          }
          console.log(`${playerName} set to: ${selectedPlayer}`);
        },
        async setWinner(winner) {
          if (this.playerOne != this.playerTwo && this.playerOne && this.playerTwo) {
              let loser = '';
              if (winner) {
                if (winner === this.playerOne) {
                    loser = this.playerTwo;
                }
                else {
                    loser = this.playerOne;
                }
              }
              else {
                  alert("nice try..choose Winner!! ;)");
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
              }
              catch (error) {
                  console.error('Error updating Elo points:', error.message);
              }
              this.winner = winner;
          }
          else {
              alert('Choose two different players and no dublicates');
          }
        },
        async startGame() {
            if (this.playerOne && this.playerTwo && this.playerOne != this.playerTwo) {
                const { winner, loser } = randomizer(this.playerOne, this.playerTwo);
                try {
                    await fetch('http://localhost:3000/updateElo', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ winner, loser })
                    });
                    this.eloPoints = 'placeholder'
                    console.log(`Game finished! Winner: ${winner}, Loser: ${loser}`);
                    alert(`Game finished! Winner: ${winner}, Loser: ${loser}`);
                }
                catch (error) {
                    console.error('Error updating Elo points:', error.message);
                }
            }
            else {
                alert('Please select both players and no dublicates.');
            }
        }
    },
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
