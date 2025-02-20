<template>
    <navigationBar></navigationBar>
    <div class="tournament">
        <h2>Tournament</h2>
        <div class="selectTeams">
            <div v-for="(round, roundIndex) in rounds" :key="'round-' + roundIndex" class="round">
                <h3>Round {{ roundIndex + 1 }}</h3>
                <div v-for="(teamPair, matchIndex) in round" :key="'match-' + matchIndex" class="match">
                    <div class="teams">
                        <TeamPicks
                            :team="teamPair.teamOne"
                            :availableTeams="availableTeams"
                            @update:teamName="setTeam(teamPair.teamOne, $event, roundIndex)"
                        />
                        <TeamPicks
                            :team="teamPair.teamTwo"
                            :availableTeams="availableTeams"
                            @update:teamName="setTeam(teamPair.teamTwo, $event, roundIndex)"
                        />
                    </div>
                    <div class="message">
                        {{ message }}
                    </div>
                    <div
                        v-if="
                            !winner &&
                            teams[teamPair.teamOne] &&
                            teams[teamPair.teamTwo] &&
                            teams[teamPair.teamOne] != teams[teamPair.teamTwo]
                        "
                        class="actions"
                    >
                        <button @click="setRandomWinner(roundIndex, matchIndex)" class="random-winner">
                            🎲 Play Randomly
                        </button>
                        <div class="chooseWinner">
                            <label for="chooseWinner">Choose Winner</label>
                            <select v-model="teamPair.chooseWinner" class="dropdown">
                                <option :value="teams[teamPair.teamOne]">
                                    {{ teams[teamPair.teamOne] }}
                                </option>
                                <option :value="teams[teamPair.teamTwo]">
                                    {{ teams[teamPair.teamTwo] }}
                                </option>
                            </select>
                            <button
                                @click="setWinner(teamPair.chooseWinner, roundIndex, matchIndex)"
                                class="set-winner"
                            >
                                🏆 Set Winner
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="finalWinner" class="champion">
                <h3>Champion: {{ finalWinner }}</h3>
            </div>
        </div>
        <RouterLink to="/" class="back-link">← Back</RouterLink>
    </div>
    <footerBar></footerBar>
</template>

<script>
import { randomizer } from '../GameLogic/Randomizer.js';
import TeamPicks from '../Atoms/TeamPicks.vue';
import navigationBar from '../Atoms/navigationBar.vue';
import footerBar from '../Atoms/footerBar.vue';

export default {
    name: 'TeamTournament',
    components: {
        TeamPicks,
        navigationBar,
        footerBar,
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
                teamEight: '',
            },
            message: '',
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
        this.fetchTeams();
    },
    methods: {
        async fetchTeams() {
            try {
                const response = await fetch('http://localhost:3000/getActiveteams');
                const data = await response.json();
                this.availableTeams = data;
            } catch (error) {
                console.error('Error fetching teams:', error.message);
            }
        },

        setTeam(teamName, selectedTeam, roundIndex) {
            const currentRoundTeams = this.rounds[roundIndex]
                .flatMap(match => [this.teams[match.teamOne], this.teams[match.teamTwo]])
                .filter(team => team);
            if (currentRoundTeams.includes(selectedTeam)) {
                this.message = 'Dieses Team wurde in dieser Runde bereits ausgewählt!';
                return;
            }
            this.teams[teamName] = selectedTeam;
            this.message = '';
        },

        async setRandomWinner(roundIndex, matchIndex) {
            const match = this.rounds[roundIndex][matchIndex];
            const teamOne = match.teamOne;
            const teamTwo = match.teamTwo;

            if (this.teams[teamOne] && this.teams[teamTwo]) {
                const { winner } = randomizer(this.teams[teamOne], this.teams[teamTwo]);
                match.chooseWinner = winner;
                this.advanceToNextRound(roundIndex);
            } else {
                this.message = 'Please select both teams.';
            }
        },

        async setWinner(winner, roundIndex, matchIndex) {
            if (!winner) {
                this.message = 'Please choose a winner!';
                return;
            }

            const match = this.rounds[roundIndex][matchIndex];
            match.chooseWinner = winner;
            this.advanceToNextRound(roundIndex);
        },

        advanceToNextRound(roundIndex) {
            const currentRound = this.rounds[roundIndex];
            if (currentRound.some(match => !match.chooseWinner)) {
                this.message = 'Please finish all matches in this round.';
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
.tournament {
    padding: 20px;
    font-family: 'Roboto', sans-serif;
    background-color: #f4f4f4;
    border-radius: 12px;
    max-width: 800px;
    margin: 50px auto;
    text-align: center;
}

.round {
    margin-bottom: 30px;
    padding: 20px;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
}

.actions {
    margin-top: 10px;
}

.random-winner,
.set-winner {
    padding: 10px 15px;
    font-size: 14px;
    font-weight: bold;
    color: white;
    background-color: #007bff;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.random-winner:hover,
.set-winner:hover {
    background-color: #0056b3;
}

.chooseWinner {
    margin-top: 10px;
}

.dropdown {
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 6px;
    margin-right: 10px;
}

.champion {
    font-size: 18px;
    font-weight: bold;
    color: #4caf50;
    margin-top: 20px;
}

.back-link {
    display: inline-block;
    margin-top: 20px;
    color: #007bff;
    text-decoration: none;
    font-weight: bold;
}

.back-link:hover {
    color: #0056b3;
}
</style>
