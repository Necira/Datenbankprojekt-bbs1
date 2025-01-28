<template>
  <h2> Tournament </h2>
  <div class="selectTeams">
    <div v-for="(round, roundIndex) in rounds" :key="'round-' + roundIndex" class="round">
      <h3>Round {{ roundIndex + 1 }}</h3>
      <div v-for="(teamPair, matchIndex) in round" :key="'match-' + matchIndex">
        <TeamPicks 
          :team="teamPair.teamOne" 
          :availableTeams="availableTeams" 
          @update:teamName="setTeam(teamPair.teamOne, $event)" 
        />
        <TeamPicks 
          :team="teamPair.teamTwo" 
          :availableTeams="availableTeams" 
          @update:teamName="setTeam(teamPair.teamTwo, $event)" 
        />
        
        <button 
          v-if="teams[teamPair.teamOne] && teams[teamPair.teamTwo]" 
          @click="setRandomWinner(roundIndex, matchIndex)"
        >
          Play Randomly
        </button>
        
        <div 
          class="chooseWinner" 
          v-if="teams[teamPair.teamOne] && teams[teamPair.teamTwo]"
        >
          <label for="chooseWinner">Choose Winner</label>
          <select v-model="teamPair.chooseWinner">
            <option :value="teams[teamPair.teamOne]">
              {{ teams[teamPair.teamOne] }}
            </option>
            <option :value="teams[teamPair.teamTwo]">
              {{ teams[teamPair.teamTwo] }}
            </option>
          </select>
          <button 
            @click="setWinner(teamPair.chooseWinner, roundIndex, matchIndex)"
          >
            Set Winner
          </button>
        </div>
      </div>
    </div>

    <div v-if="finalWinner">
      <h3>Champion: {{ finalWinner }}</h3>
    </div>

    <RouterLink to="/">Back</RouterLink>
  </div>
</template>

<script>
import { gameLogic } from '../GameLogic/GameLogic.js';
import TeamPicks from '../Atoms/TeamPicks.vue';
import WinnerMessage from '../Atoms/WinnerMessage.vue';

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
      rounds: [
        [
          { teamOne: 'first Team', teamTwo: 'second Team', chooseWinner: '' },
          { teamOne: 'third Team', teamTwo: 'fourth Team', chooseWinner: '' },
          { teamOne: 'fifth Team', teamTwo: 'sixth Team', chooseWinner: '' },
          { teamOne: 'seventh Team', teamTwo: 'eight Team', chooseWinner: '' },
        ],
      ],
      finalWinner: null,
    };
  },
  created() {
    this.fetchteams();
  },
  methods: {
    async fetchteams() {
      console.log("Fetching teams...");
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

    async setRandomWinner(roundIndex, matchIndex) {
      const match = this.rounds[roundIndex][matchIndex];
      const teamOne = match.teamOne;
      const teamTwo = match.teamTwo;

      if (this.teams[teamOne] && this.teams[teamTwo]) {
        const { winner } = gameLogic(this.teams[teamOne], this.teams[teamTwo]);
        match.chooseWinner = winner;
        this.advanceToNextRound(roundIndex);
      } else {
        alert('Please select both teams.');
      }
    },

    async setWinner(winner, roundIndex, matchIndex) {
      if (!winner) {
        alert("Please choose a winner!");
        return;
      }

      const match = this.rounds[roundIndex][matchIndex];
      match.chooseWinner = winner;
      this.advanceToNextRound(roundIndex);
    },

    advanceToNextRound(roundIndex) {
      const currentRound = this.rounds[roundIndex];
      if (currentRound.some(match => !match.chooseWinner)) {
        alert('Please finish all matches in this round first.');
        return;
      }

      const winners = currentRound.map(match => match.chooseWinner);

      if (winners.length === 1) {
        this.finalWinner = winners[0];
        return;
      }

      const nextRound = [];
      for (let i = 0; i < winners.length; i += 2) {
        nextRound.push({
          teamOne: winners[i],
          teamTwo: winners[i + 1] || null,
          chooseWinner: '',
        });
      }

      this.rounds.push(nextRound);
    },
  },
};
</script>

<style scoped>
.selectTeams {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.round {
  margin-bottom: 20px;
}

.chooseWinner {
  margin-top: 10px;
}

button {
  margin: 10px;
}
</style>
